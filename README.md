<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ngrok_utility.sh</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      padding: 20px;
    }
    
    h1 {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 20px;
    }
    
    h2 {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 10px;
    }
    
    h3 {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 10px;
    }
    
    p {
      margin-bottom: 10px;
    }
    
    code {
      font-family: Consolas, monospace;
      background-color: #f1f1f1;
      padding: 2px 5px;
    }
    
    pre {
      background-color: #f1f1f1;
      padding: 10px;
      overflow-x: auto;
      max-width: 100%;
    }
    
    .options {
      margin-top: 20px;
    }
    
    .option {
      display: flex;
      align-items: center;
      margin-bottom: 10px;
    }
    
    .option .flag {
      font-family: Consolas, monospace;
      background-color: #f1f1f1;
      padding: 2px 5px;
      margin-right: 10px;
    }
    
    .option .description {
      margin-left: 5px;
    }
    
    .license {
      margin-top: 20px;
    }
    
    .license a {
      color: #0366d6;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <h1>ngrok_utility.sh</h1>
  
  <h2>Features</h2>
  <ul>
    <li>Start ngrok to expose a local server to the internet.</li>
    <li>Stop ngrok if it is currently running.</li>
    <li>Extract session information from ngrok.</li>
    <li>Secure the ngrok service by setting up authentication.</li>
    <li>Run ngrok in debug mode for troubleshooting.</li>
    <li>Display help information and usage instructions.</li>
  </ul>
  
  <h2>Prerequisites</h2>
  <ul>
    <li>Bash shell</li>
    <li>ngrok installed and accessible via the command line</li>
    <li>Required dependencies: nohup, ipcalc</li>
  </ul>
  
  <h2>Usage</h2>
  <ol>
    <li>Clone or download this repository to your local machine.</li>
    <li>Make sure the script is executable: <code>chmod +x ngrok_utility.sh</code></li>
    <li>Run the script: <code>./ngrok_utility.sh [options]</code></li>
  </ol>
  
  <h2>Options</h2>
  <div class="options">
    <div class="option">
      <div class="flag">-k</div>
      <div class="description">--kill: Stop the currently running ngrok process.</div>
    </div>
    <div class="option">
      <div class="flag">-i</div>
      <div class="description">--sess-info: Extract and display session information from ngrok.</div>
    </div>
    <div class="option">
      <div class="flag">-S</div>
      <div class="description">--secure: Secure the ngrok service by setting up authentication.</div>
    </div>
    <div class="option">
      <div class="flag">-r</div>
      <div class="description">--run: Start ngrok and expose a local server to the internet.</div>
    </div>
    <div class="option" style="margin-left: 20px;">
      <div class="flag">--debug</div>
      <div class="description">Run ngrok in debug mode for troubleshooting.</div>
    </div>
    <div class="option">
      <div class="flag">-h</div>
      <div class="description">--help: Display help information and usage instructions.</div>
    </div>
  </div>
  
  <div class="license">
    <h3>License</h3>
    <p>This script is licensed under the <a href="#">MIT License</a>. See the <a href="#">LICENSE</a> file for more details.</p>
  </div>
</body>
</html>
