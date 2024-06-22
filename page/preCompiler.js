const fs = require('fs');
const path = require('path');

// Directory path to be read
const directoryPath = 'D:/SpawnCycler/cycles';

// Object to store file data
const fileData = {};

// Read directory
fs.readdir(directoryPath, (err, files) => {
  if (err) {
    return console.error('Unable to scan directory: ' + err);
  }

  targetCycleList = [
    'albino_heavy',
    'basic_light',
    'basic_moderate',
    'basic_heavy',
    'dtf_v1',
    'nam_poundemonium',
    'nam_pro_v1',
    'nam_pro_v2',
    'nam_pro_v3',
    'nam_pro_v4',
    'nam_pro_v5',
    'nam_pro_v5_plus',
    'nam_semi_pro',
    'nam_semi_pro_v2',
    'rd_kta',
    'rd_odt',
    'rd_sam',
    'asl_v1',
    'asl_v2',
    'asl_v3',
    'pubs_v1',
    'ts_mig_v1',
    'ts_mig_v2',
    'ts_mig_v3',
    'ts_mig_v1_p',
    'ts_lk313_stg',
    'doom_v1',
    'doom_v2',
    'doom_v2_plus',
    'doom_v2_short',
    'grand_v1',
    'bl_v1',
    'bl_v2',
    'osffi_v1',
    'doomsday_v1',
    'fpp_v1',	
    'pro6',
    'pro6_plus',
    'pro_short',
    'mko_v1',
    'doom_v2_plus_rmk',
    'asp_v1',
    'asp_v2',
    'asp_v3',
    'asp_fp_v1',
    'asp_fp_v2',
    'osffi_v1_ms',
    'machine_solo',
    'bl_light',
    'su_v1_short',
    'su_v1',
    'poopro_v1',
    'dtf_pm',
    'dtf_pm_plus',
    'dtf_pm_plus_fx',
    'who_v1',
    'who_v2',
    'ebr_hh_v1',
    'nt_v2',
    'jhhc_v1',
    'jhscc_v1'
  ];

  // Filter .txt files
  const filteredFiles = files.filter(file =>
    path.extname(file) === '.txt' && targetCycleList.includes(path.basename(file, '.txt'))
  );

  // Read each filtered file
  for (const file of filteredFiles){
    const filePath = path.join(directoryPath, file);
    const fileNameWithoutExt = path.basename(file, '.txt');

    try{
      const data = fs.readFileSync(filePath, 'utf-8');
      const spawnCycleDefs = data.replace(/SpawnCycleDefs=/g, '').split('\r\n');
      fileData[fileNameWithoutExt] = spawnCycleDefs;
    } catch(err){
      console.error('Unable to read file: ' + err);
    }
  }
  
  // Write the final file data object to fileData.json
  // Define the relative path to save the file
  const outputPath = path.join(__dirname, 'spawnCycle.json');

  fs.writeFile(outputPath, JSON.stringify(fileData, null, 2), (err) => {
    if (err) {
      return console.log('Unable to write to file: ' + err);
    }
    console.log('spawnCycle.json has been saved.');
  });
});