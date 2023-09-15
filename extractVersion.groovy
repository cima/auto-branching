def config = readJSON file: "uuapp.json"
echo "App (${APP}) version: ${config.version}"
String[] components = config.version.split("\\.")
String[] patchComponents = components[2].split('-')
env.majorVersion = components[0];
env.minorVersion = components[1];
env.patchVersion = patchComponents[0];
env.versionSuffix = "";
echo "Major ${env.majorVersion}"
echo "Minor ${env.minorVersion}"
echo "Patch ${env.patchVersion}"
if(patchComponents.length > 1){
    env.versionSuffix = patchComponents[1];
    echo "Suffix ${env.versionSuffix}"
}