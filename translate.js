const fs = require('fs');
const path = require('path');
const { GoogleGenerativeAI } = require('@google/generative-ai');

// NOTE: Set your API key in the environment or replace here
const ai = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "AIzaSy...");

const localeDir = path.join(__dirname, 'locale');
const sourceFile = path.join(localeDir, 'ja.arb');

// The keys we specifically refined in Japanese
const keysToUpdate = [
    "status_unsupported_desc",
    "status_connected_desc",
    "wsa_manage_app",
    "wsa_manage_settings",
    "settings_option_generic_disabled",
    "theme_mica",
    "theme_mica_full",
    "theme_mica_partial",
    "theme_icon_adaptive_squircle",
    "theme_icon_adaptive_rounded_square"
];

async function run() {
    const jaData = JSON.parse(fs.readFileSync(sourceFile, 'utf8'));

    // Extract context from Japanese file
    let jaContext = "Target Keys to translate based on this Japanese Source Context:\n";
    for (const key of keysToUpdate) {
        jaContext += `${key}: "${jaData[key]}"\n`;
    }

    const files = fs.readdirSync(localeDir).filter(f => f.endsWith('.arb') && f !== 'ja.arb');

    for (const file of files) {
        const filePath = path.join(localeDir, file);
        const localeCode = path.basename(file, '.arb');

        console.log(`Processing ${localeCode}...`);
        let targetData = JSON.parse(fs.readFileSync(filePath, 'utf8'));

        // Extract current target values for context
        let targetContext = `Current translations for locale '${localeCode}':\n`;
        for (const key of keysToUpdate) {
            if (targetData[key]) {
                targetContext += `${key}: "${targetData[key]}"\n`;
            }
        }

        const prompt = `
You are an expert app translator. 
I have updated the Japanese translations for an app to make them more natural.
I need you to update the translations in another language ('${localeCode}') to match the new natural meaning established in the Japanese translations, replacing any literal/robotic translations.

### JAPANESE SOURCE (New natural meaning):
${jaContext}

### CURRENT TARGET STRINGS ('${localeCode}'):
${targetContext}

### INSTRUCTIONS:
Return ONLY a raw JSON object containing the updated key-value pairs for '${localeCode}'. 
Ensure the new translations sound natural and correct in '${localeCode}'. 
Do NOT include any markdown formatting like \`\`\`json. Just the raw JSON object.
Make sure you retain placeholders like {windowsVersion} if they exist.
    `;

        try {
            const model = ai.getGenerativeModel({ model: 'gemini-2.5-flash' });
            const response = await model.generateContent(prompt);

            let jsonText = response.response.text().trim();
            if (jsonText.startsWith('```json')) {
                jsonText = jsonText.substring(7);
            }
            if (jsonText.endsWith('```')) {
                jsonText = jsonText.substring(0, jsonText.length - 3);
            }

            const updatedKeys = JSON.parse(jsonText);

            let modified = false;
            for (const key of keysToUpdate) {
                if (updatedKeys[key] && targetData[key] !== updatedKeys[key]) {
                    console.log(`  [${key}] ${targetData[key]} --> ${updatedKeys[key]}`);
                    targetData[key] = updatedKeys[key];
                    modified = true;
                }
            }

            if (modified) {
                fs.writeFileSync(filePath, JSON.stringify(targetData, null, 2) + '\n');
                console.log(`Saved ${file}`);
            }
        } catch (err) {
            console.error(`Error processing ${file}:`, err);
        }

        // Slight delay to prevent rate limits just in case
        await new Promise(r => setTimeout(r, 1000));
    }
}

run();
