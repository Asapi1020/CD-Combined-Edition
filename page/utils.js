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

  let cycleAnalysis = [];
  let totalAnalysis = {
    'category': {},
    'type': {},
    'group': {}
  };

  // find target spawn cycle definition and apply game length
  const targetSpawnCycleDefs = spawnCycleDefs[spawnCycle];
  const cycleDefsApplyedGameLen = extractDefsByGameLen(targetSpawnCycleDefs, gameLength);
  
  // analyze for each wave
  let waveNum = 0;
  let matchSize = 0;
  for(let waveDef of cycleDefsApplyedGameLen){
    // calculate wave size and analyze wave with it
    const waveSize = calcWaveSize(waveNum, gameLength, difficulty, wsf);
    const waveAndTotalAnalysis = analyzeWave(waveDef, waveSize, totalAnalysis);

    // register the results
    cycleAnalysis.push(waveAndTotalAnalysis.waveAnalysis);
    totalAnalysis = waveAndTotalAnalysis.totalAnalysis;
    ++waveNum;
    matchSize += waveSize;
  }

  // register the final output of total count
  totalAnalysis = addPctPropertyToAnalysis(totalAnalysis, matchSize);
  totalAnalysis.category.Total = {};
  totalAnalysis.category.Total.num = matchSize;
  cycleAnalysis.push(totalAnalysis);
  return cycleAnalysis;
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
          return targetSpawnCycleDefs;
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

/**
 * 
 * @param {String} waveDef e.g) 3GF*_1FP!,1CY_10CR
 * @param {Number} waveSize totalAI in a wave
 * @returns {Object} {
 *  'category': {
 *    "Large": {"num": 12, "spawnRage": 5},
 *    "Medium": {"num": 12, "spawnRage": 0},
 *    "Trash": {}
 *  },
 *  'type': {same},
 *  'group': {same}
 * }
 */
function analyzeWave(waveDef, waveSize, totalAnalysis){
  let waveAnalysis = {
    'category': {},
    'type': {},
    'group': {}
  };
  let spawnCount = 0;

  const squads = waveDef.split(",");
  
  do{
    for(let squad of squads){
      const groups = squad.split("_");
  
      for(let group of groups){
        const groupInfo = parseGroupInfo(group);
  
        if(spawnCount + groupInfo.groupSize > waveSize){
          // at the end of wave, you should cut the group
          groupInfo.groupSize = waveSize - spawnCount;
        }
  
        spawnCount += groupInfo.groupSize;
        waveAnalysis = addCountToAnalysis(waveAnalysis, groupInfo);
        totalAnalysis = addCountToAnalysis(totalAnalysis, groupInfo); // this is sum of wave 1 to here
  
        if(spawnCount >= waveSize){
          // done to count up this wave. It's time to calc percentage
          waveAnalysis = addPctPropertyToAnalysis(waveAnalysis, waveSize);
          waveAnalysis.category.Total = {};
          waveAnalysis.category.Total.num = waveSize;
          return {
            waveAnalysis,
            totalAnalysis
          };
        }
      };
    };
  }while(spawnCount < waveSize)
  
  console.log('something error');
  return {
    waveAnalysis,
    totalAnalysis
  };
}

// (e.g) 3GF* -> {groupSize: 3, zedName: Gorefiend, categoryName: Trash, groupName: Gorefasts, albino: true, spawnRage: false}
function parseGroupInfo(group){
  // (e.g) 3GF* -> [3, GF, *]
  const parsedGroupDef = group.match(/(^\d+)|([A-Za-z]+)|([*!]$)/g);

  if(parsedGroupDef.length < 2){
    console.error(`GroupDef is collapsed: ${group}`);
    return{};
  }

  const groupInfo = {};
  groupInfo.groupSize = parseInt(parsedGroupDef[0]);

  let zedCode = parsedGroupDef[1].toUpperCase();
  let codeSuffix = (parsedGroupDef.length === 3) ? parsedGroupDef[2] : '';

  // handle ST* and HU*
  if(codeSuffix === "*" && (zedCode === "ST" || zedCode === "HU")){
    const rand = Math.floor(Math.random() * 3);
    switch(rand){
      case 0:
        zedCode = 'DE';
        break;
      case 1:
        zedCode = 'DL';
        break;
      case 2:
        zedCode = 'DR';
        break;
      default:
        console.error(`something wrong with random output: ${rand}`);
        break;
    }
    codeSuffix = '';
  }

  groupInfo.albino = codeSuffix === "*";
  groupInfo.spawnRage = codeSuffix === "!";

  switch(zedCode){
    case 'CY':
    case 'CC':
      groupInfo.zedName = 'Cyst';
      groupInfo.categoryName = 'Trash';
      groupInfo.groupName = 'Clots';
      break;
    case 'AL':
    case 'CA':
      groupInfo.zedName = (codeSuffix === '*') ? 'Rioter' : 'Alpha Clot';
      groupInfo.categoryName = 'Trash';
      groupInfo.groupName = 'Clots';
      break;
    case 'SL':
    case 'CS':
      groupInfo.zedName = 'Slasher';
      groupInfo.categoryName = 'Trash';
      groupInfo.groupName = 'Clots';
      break;
    case 'GF':
      groupInfo.zedName = (codeSuffix === '*') ? 'Gorefiend' : 'Gorefast';
      groupInfo.categoryName = 'Trash';
      groupInfo.groupName = 'Gorefasts';
      break;
    case 'CR':
      groupInfo.zedName = (codeSuffix === '*') ? 'Elite Crawler' : 'Crawler';
      groupInfo.categoryName = 'Trash';
      groupInfo.groupName = 'Crawlers_Stalkers';
      break;
    case 'ST':
      groupInfo.zedName = 'Stalker'; // TODO: consider st*
      groupInfo.categoryName = 'Trash';
      groupInfo.groupName = 'Crawlers_Stalkers';
      break;
    case 'BL':
      groupInfo.zedName = 'Bloat';
      groupInfo.categoryName = 'Medium';
      groupInfo.groupName = 'Other';
      break;
    case 'HU':
      groupInfo.zedName = 'Husk'; // TODO: consider hu*
      groupInfo.categoryName = 'Medium';
      groupInfo.groupName = 'Other';
      break;
    case 'SI':
      groupInfo.zedName = 'Siren';
      groupInfo.categoryName = 'Medium';
      groupInfo.groupName = 'Other';
      break;
    case 'DE':
      groupInfo.zedName = 'EDAR Trapper';
      groupInfo.categoryName = 'Medium';
      groupInfo.groupName = 'Robots';
      break;
    case 'DL':
      groupInfo.zedName = 'EDAR Blaster';
      groupInfo.categoryName = 'Medium';
      groupInfo.groupName = 'Robots';
      break;
    case 'DR':
      groupInfo.zedName = 'EDAR Bomber';
      groupInfo.categoryName = 'Medium';
      groupInfo.groupName = 'Robots';
      break;
    case 'SC':
      groupInfo.zedName = 'Scrake';
      groupInfo.categoryName = 'Large';
      groupInfo.groupName = 'Scrakes';
      break;
    case 'QP':
    case 'MF':
      groupInfo.zedName = 'Quarterpound';
      groupInfo.categoryName = 'Large';
      groupInfo.groupName = 'Fleshpounds';
      break;
    case 'FP':
      groupInfo.zedName = 'Fleshpound';
      groupInfo.categoryName = 'Large';
      groupInfo.groupName = 'Fleshpounds';
      break;
    default:
      console.error(`Failed to identify zed: ${zedCode}`);
      groupInfo.zedName = 'Unknown';
      break;
  }

  return groupInfo;
}

function addCountToAnalysis(analysis, groupInfo){
  // type
  if(!analysis.type[groupInfo.zedName]){
    analysis.type[groupInfo.zedName] = {};
  }
  analysis.type[groupInfo.zedName].num = (analysis.type[groupInfo.zedName].num || 0) + groupInfo.groupSize;

  // category
  if(!analysis.category[groupInfo.categoryName]){
    analysis.category[groupInfo.categoryName] = {};
  }
  analysis.category[groupInfo.categoryName].num = (analysis.category[groupInfo.categoryName].num || 0) + groupInfo.groupSize;

  // group
  if(!analysis.group[groupInfo.groupName]){
    analysis.group[groupInfo.groupName] = {};
  }
  analysis.group[groupInfo.groupName].num = (analysis.group[groupInfo.groupName].num || 0) + groupInfo.groupSize;

  // albino
  if(groupInfo.albino){
    if(!analysis.group.Albino){
      analysis.group.Albino = {};
    }
    analysis.group.Albino.num = (analysis.group.Albino.num || 0) + groupInfo.groupSize;
  }

  // add spawn rage count
  if(groupInfo.spawnRage){
    analysis.type[groupInfo.zedName].spawnRage = (analysis.type[groupInfo.zedName].spawnRage || 0) + groupInfo.groupSize;
    analysis.category[groupInfo.categoryName].spawnRage = (analysis.category[groupInfo.categoryName].spawnRage || 0) + groupInfo.groupSize;
    analysis.group[groupInfo.groupName].spawnRage = (analysis.group[groupInfo.groupName].spawnRage || 0) + groupInfo.groupSize;
  }

  return analysis;
}

function addPctPropertyToAnalysis(analysis, waveSize){
  const namekeys = Object.keys(analysis);

  for(let nameKey of namekeys){
    const zedKeys = Object.keys(analysis[nameKey]);
    
    for(let zedKey of zedKeys){
      analysis[nameKey][zedKey].pct = (100 * analysis[nameKey][zedKey].num / waveSize).toFixed(2);
    }
  }

  return analysis;
}

module.exports  = {
  extractDefsByGameLen,
  calcWaveSize,
  analyzeWave
};