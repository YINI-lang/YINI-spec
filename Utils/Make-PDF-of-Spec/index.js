import MarkdownIt from 'markdown-it';
import fs from 'fs';
import puppeteer from "puppeteer";
import { fileURLToPath } from 'node:url';

const inFile = '../../YINI-Specification.md'
const outFile = '../../YINI-Specification.pdf'

// Read and convert Markdown to HTML.
const md = new MarkdownIt();
const markdown = fs.readFileSync(inFile, 'utf-8');
const innerHTML = md.render(markdown);
// console.log(innerHTML);

// Load GitHub Markdown CSS and a custom print stylesheet
const ghCssUrl = import.meta.resolve('github-markdown-css/github-markdown.css');
const ghCssPath = fileURLToPath(ghCssUrl);
const ghCss = await fs.promises.readFile(ghCssPath, 'utf8');

// Styled HTML template
const html = `<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<style>${ghCss}</style>
</head>
<body>
  <div class="container">

    <article class="markdown-body">
      ${innerHTML}
    </article>

    </div>
</body>
</html>`;

// Launch headless Chrome and generate PDF.
const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.setContent(html, { waitUntil: "networkidle0" });
await page.pdf({
    path: outFile, 
    format: "A4",
    printBackground: false,
    preferCSSPageSize: false,   // let @page size rule win
    margin: { top: "10mm", right: "10mm", bottom: "10mm", left: "10mm" } 
});
await browser.close();

