const fs = require("node:fs");

const compiledSrc = fs.readFileSync(0, "utf-8");

const initRegex = /this\.Gren\..+\(\{\}\)/g;
const initCall = compiledSrc.match(initRegex)[0];

const snapshotCompatibleSrc = compiledSrc.replace(
  initCall,
  `
require('node:v8').startupSnapshot.setDeserializeMainFunction(function() {
  ${initCall}
})
`,
);

console.log(snapshotCompatibleSrc)
