const fs = require('fs');
const path = require('path');

const pluginPath = path.join(__dirname, '..', 'node_modules', '@capacitor', 'app', 'ios', 'Sources', 'AppPlugin', 'AppPlugin.swift');

if (fs.existsSync(pluginPath)) {
  let content = fs.readFileSync(pluginPath, 'utf8');
  if (content.includes('call.reject("Unable to get App Info")')) {
    content = content.replace('call.reject("Unable to get App Info")', 'call.resolve([:])');
    fs.writeFileSync(pluginPath, content, 'utf8');
    console.log('[patch] Successfully patched AppPlugin.swift call.reject -> call.resolve([:])');
  } else {
    console.log('[patch] AppPlugin.swift already patched or pattern not found.');
  }
} else {
  console.log('[patch] AppPlugin.swift does not exist at ' + pluginPath);
}
