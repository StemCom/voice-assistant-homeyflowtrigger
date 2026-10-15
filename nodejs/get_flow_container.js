import { HomeyAPI } from 'homey-api';
import fs from 'fs';
import os from 'os';
import path from 'path';

// Load configuration from user config directory
const configPath = path.join(os.homedir(),'.config', 'ovos_skill_homeyflowtrigger', 'config.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

// test of de config juist gelezen wordt
console.error(`HOMEY_ADDR: ${config.homey.address}`);
console.error(`CONFIG_PATH: ${configPath}`);

const searchString = process.argv[2] || "";
console.log("Directory to config file:", configPath);

async function getFilteredFlows() {
  try {
    // Connect to the Homey API
    const homeyApi = await HomeyAPI.createLocalAPI({
      address: config.homey.address, // Load address from config
      token: config.homey.token      // Load token from config
    });

    // Get all flows from Homey
    const flows = await homeyApi.flow.getFlows();


    // Filter flows based on the search string
    const filteredFlows = Object.values(flows).filter(flow =>
      flow.name.toLowerCase().includes(searchString.toLowerCase())
    );

    // Format the filtered flows in the flow_mappings.json structure
    const flowMappings = {};
    filteredFlows.forEach(flow => {
      flowMappings[flow.name] = {
        id: flow.id,
        sentences: [] // Empty sentences array, as this will be populated later
      };
    });

    // Return the filtered flows to the Python script
    // Virtual environment, uses TTY in stdout direct send
    //console.error(JSON.stringify(flowMappings));
    // Container, stdout is buffered
    process.stdout.write(JSON.stringify(flowMappings) + "\n");

    //console.log("Flows zijn verzonden");
  } catch (error) {
    console.log("Een fout in het verkrijgen van de flow", error.message);
    process.exit(1); // Exit with an error code
  }
}

// Execute the function
getFilteredFlows();