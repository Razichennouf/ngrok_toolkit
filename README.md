<!DOCTYPE html>
<html lang="en">

</head>
<body>
  <h1>ngrok_utility.sh</h1>
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
  <h2>💡 Why Use These Scripts:</h2>

<h2 style="color: #0366d6;">Description:</h2>

<p>The script collection is a set of powerful tools designed to simplify and enhance your experience with ngrok, a popular tunneling service. These scripts provide a convenient command-line interface to manage ngrok processes, extract session information, secure services, and more. Whether you are a developer, system administrator, or enthusiast, these scripts will help you streamline your ngrok workflow and improve productivity.</p>

<h2 style="color: #0366d6;">Key Features:</h2>

<ul>
  <li>⚙️ Process Management: Easily start, stop, and check the status of ngrok processes running on your system.</li>
  <li>🔍 Session Information Extraction: Extract detailed information about active ngrok sessions, including public URLs, tunnel protocols, and more.</li>
  <li>🔒 Service Security: Secure your ngrok service by enabling additional security measures.</li>
  <li>🔐 Token Validation: Validate and configure your ngrok authentication token for seamless integration.</li>
  <li>🐞 Debug Mode: Run ngrok in debug mode to troubleshoot and diagnose issues with detailed logging.</li>
  <li>ℹ️ Convenient Help Menu: Access a comprehensive help menu providing instructions and usage guidelines for each command.</li>
</ul>

<h2 style="color: #0366d6;">Requirements:</h2>

<ul>
  <li>Bash (Bourne Again Shell)</li>
  <li>ngrok (installed and accessible in the system's PATH)</li>
</ul>

<h2 style="color: #0366d6;">Usage:</h2>

<ol>
  <li>Clone the repository: <code>git clone https://github.com/your-username/your-repository.git</code></li>
  <li>Navigate to the script directory: <code>cd your-repository</code></li>
  <li>Make the script executable: <code>chmod +x ngrok_utility.sh</code></li>
  <li>Run the script: <code>./ngrok_utility.sh [command] [options]</code></li>
</ol>

<h2 style="color: #0366d6;">Commands:</h2>

<ul>
  <li><code>-k</code>, <code>--kill</code>: Stop the running ngrok process.</li>
  <li><code>-i</code>, <code>--sess-info</code>: Extract session information for active ngrok tunnels.</li>
  <li><code>-S</code>, <code>--secure</code>: Enable additional security measures for your ngrok service.</li>
  <li><code>-h</code>, <code>--help</code>: Display the help menu with command descriptions and usage guidelines.</li>
  <li><code>-r</code>, <code>--run</code>: Start ngrok and expose your local service to the internet.
    <ul>
      <li>Use <code>--debug</code> for running ngrok in debug mode.</li>
    </ul>
  </li>
</ul>

<h2 style="color: #0366d6;">Note:</h2>

<p>Please ensure that you have the necessary permissions to execute the script, and make sure to provide a valid ngrok authentication token when prompted.</p>

<p>Feel free to explore the script collection and customize it according to your needs.</p>

<p>Happy ngrok-ing!</p>
  <h3>🌟 Explore the repository, star it, and contribute to the scripts to make them even better. Let's empower each other and simplify our daily tasks with the power of automation.</h3>
</body>
</html>

