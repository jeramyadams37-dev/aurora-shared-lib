/**
 * geminiClient.js — Shared, tested Gemini API wrapper
 * Fixes the recurring "no-content" bug.
 */
const GEMINI_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

export async function generateInsight({ apiKey, prompt, context = "", temperature = 0.7 }) {
  if (!apiKey) throw new Error("[geminiClient] Missing API key.");
  if (!prompt || typeof prompt !== "string" || prompt.trim().length === 0) {
    throw new Error("[geminiClient] No prompt provided.");
  }
  const fullText = context && context.trim().length > 0 ? `${prompt}\n\n---\nContext:\n${context}` : prompt;
  const body = { contents: [{ role: "user", parts: [{ text: fullText }] }], generationConfig: { temperature } };
  const response = await fetch(`${GEMINI_ENDPOINT}?key=${apiKey}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
  if (!response.ok) throw new Error(`Gemini API error ${response.status}`);
  const data = await response.json();
  const text = data?.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) throw new Error("Gemini returned no usable content.");
  return { text, raw: data };
}
