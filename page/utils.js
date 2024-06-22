/**
 * @param {string} spawnCycle
 * @param {number} gameLength 0: Short, ..., 2: Long
 * @param {number} difficulty 0: Normal, ..., 3: HoE
 * @param {number} wsf 1~32
 * @return {object[]} [ { zedName: count, ... }, ..., {} ]
 */
function analyzeCycle(spawnCycle, gameLength, difficulty, wsf){
  console.log({
    spawnCycle,
    gameLength,
    difficulty,
    wsf
  });

  // calculate
  const targetSpawnCycleDefs = spawnCycleDefs[spawnCycle];
  const cycleDefsApplyedGameLen = extractDefsByGameLen(targetSpawnCycleDefs, gameLength);
  
  cycleDefsApplyedGameLen.forEach((waveDef, waveNum) => {
    const waveSize = calcWaveSize(waveNum, gameLength, difficulty, wsf);
    const waveAnalysis = analyzeWave(waveDef, waveSize);
  });
}

/**
 * @param   {string[]} targetSpawnCycleDefs 
 * @param   {number} gameLength 
 * @returns {string[]} - cycleDefsApplyedGameLen
 * convert defs length
 * (e.g) extract wave 1,4,7,10 for Long cycle to be compatible with short game
 */
function extractDefsByGameLen(targetSpawnCycleDefs, gameLength){
  const defLength = targetSpawnCycleDefs.length;

  switch(gameLength){
    // short
    case 0:
      if(defLength === 4){
        return targetSpawnCycleDef;
      }
      else if(defLength === 7){
        // [0, 1, 2, 3, 4, 5, 6] -> [0, 2, 4, 6]
        targetSpawnCycleDefs.splice(5,1);
        targetSpawnCycleDefs.splice(3,1);
        targetSpawnCycleDefs.splice(1,1);
        return targetSpawnCycleDef;
      }
      else if(defLength === 10){
        // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] -> [0,  3,  6,  9]
        targetSpawnCycleDefs.splice(7,2);
        targetSpawnCycleDefs.splice(4,2);
        targetSpawnCycleDefs.splice(1,2);
        return targetSpawnCycleDefs;
      }

      // error
      console.error(`Invalid def length: ${defLength}, gameLength: ${gameLength}`);
      alert('Fatal Error: Preset cycle definitions are collapsed.')
      return [];
    
    // medium
    case 1:
        if(defLength === 7){
          return targetSpawnCycleDef;
        }
        else if(defLength === 10){
          // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] -> [0, 1, 3, 5, 6, 8, 9]
          targetSpawnCycleDefs.splice(7, 1);
          targetSpawnCycleDefs.splice(4, 1);
          targetSpawnCycleDefs.splice(2, 1);
          return targetSpawnCycleDefs;
        }

        // error
        console.error(`Invalid def length: ${defLength}, gameLength: ${gameLength}`);
        alert( (defLength === 4)
          ? 'Invalid game length. Game length should be short for this cycle'
          : 'Fatal Error: Preset cycle definitions are collapsed.');
        return [];
      
    // Long
    case 2:
      if(defLength === 10){
        return targetSpawnCycleDefs;
      }

      // error
      console.error(`Invalid def length: ${defLength}, gameLength: ${gameLength}`);
      if(defLength === 4){
        alert('Invalid game length. Game length should be short for this cycle');
      }
      else if(defLength === 7){
        alert('Invalid game length. Game length should be medium for this cycle');
      }
      else{
        alert('Fatal Error: Preset cycle definitions are collapsed.');
      }
      return [];
    
    default:
      console.error(`Invalid game length: ${gameLength}`);
      alert('Fatal Error: selected game length is something wrong');
      return [];
  }
}

/**
 * @param   {number} waveNum 
 * @param   {number} gameLength 
 * @param   {number} difficulty 
 * @param   {number} wsf 
 * @return  {number} - totalAIforWave
 */
function calcWaveSize(waveNum, gameLength, difficulty, wsf){
  const defaultMultiplier = [1.0, 2.0, 2.75, 3.5, 4.0, 4.5];
  const defaultBaseNum = [
    [25, 32, 35, 42],
    [25, 28, 32, 32, 35, 40, 42],
    [25, 28, 32, 32, 35, 35, 35, 40, 42, 42]
  ];
  const defaultDifficultyMod = [0.85, 1.0, 1.3, 1.7];

  const calcMultiplier = () => {
    if(wsf < 0){
      console.error(`Wave Size Fakes must be positive but ${wsf}`);
      return 0;
    }
    else if(wsf <= 6){
      return defaultMultiplier[wsf-1];
    }
    else{
      return defaultMultiplier[5] + (wsf-6)*0.211718;
    }
  };

  const multiplier = calcMultiplier();
  const baseNum = defaultBaseNum[gameLength][waveNum];
  const difficultyMod = defaultDifficultyMod[difficulty];
  return Math.round(multiplier * baseNum * difficultyMod);
}

function analyzeWave(waveDef, waveSize){
  const analysis = {};
  let spawnCount = 0;

  // (e.g) 
  const squads = waveDef.split(",");
  
  do{
    for(let squad of squads){
      const groups = squad.split("_");
  
      for(let group of groups){
        const groupInfo = parseGroupInfo(group);
  
        if(spawnCount + groupInfo.groupSize > waveSize){
          // end of wave
          groupInfo.groupSize = waveSize - spawnCount;
        }
  
        spawnCount += groupInfo.groupSize;
        
        analysis[groupInfo.zedName] = analysis[groupInfo.zedName] || 0;
        analysis[groupInfo.zedName] += groupInfo.groupSize;
  
        if(spawnCount >= waveSize){
          return analysis;
        }
      };
    };
  }while(spawnCount < waveSize)
  
  console.log('something error');
  return analysis;
}

// (e.g) 3GF* -> {groupSize: 3, zedName: Gorefiend, spawnRage: false}
function parseGroupInfo(group){
  // (e.g) 3GF* -> [3, GF, *]
  const parsedGroupDef = group.match(/(^\d+)|([A-Za-z]+)|([*!]$)/g);

  if(parsedGroupDef.length < 2){
    console.error(`GroupDef is collapsed: ${group}`);
    return{};
  }

  const groupSize = parseInt(parsedGroupDef[0]);
  const zedCode = parsedGroupDef[1].toUpperCase();
  const codeSuffix = (parsedGroupDef.length === 3) ? parsedGroupDef[2] : '';

  const getZedNameFromCode = (code, suffix) => {
    switch(code){
      case 'CY':
        return 'Cyst';
      case 'AL':
        return (suffix === '*') ? 'Rioter' : 'Alpha Clot';
      case 'SL':
        return 'Slasher';
      case 'GF':
        return (suffix === '*') ? 'Gorefiend' : 'Gorefast';
      case 'CR':
        return (suffix === '*') ? 'Elite Crawler' : 'Crawler';
      case 'ST':
        return 'Stalker'; // TODO: consider st*
      case 'BL':
        return 'Bloat';
      case 'HU':
        return 'Husk'; // TODO: consider hu*
      case 'SI':
        return 'Siren';
      case 'DE':
        return 'EDAR Trapper';
      case 'DL':
        return 'EDAR Blaster';
      case 'DR':
        return 'EDAR Bomber';
      case 'SC':
        return 'Scrake';
      case 'QP':
        return 'Quarterpound';
      case 'FP':
        return 'Fleshpound';
      default:
        console.error(`Failed to identify zed: ${code}`);
        return 'Unknown';
    }
  };

  const zedName = getZedNameFromCode(zedCode, codeSuffix);
  const spawnRage = codeSuffix === "!";

  return {
    groupSize,
    zedName,
    spawnRage
  };
}

module.exports  = {
  extractDefsByGameLen,
  calcWaveSize,
  analyzeWave
};