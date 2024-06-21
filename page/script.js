// Init
setupSpawnCycleSelect();

// fetch cycle list and setup options for select
function setupSpawnCycleSelect(){
  const select = document.getElementById('cycle');

}

function initSpawnCycleDefsMap(){
  const spawnCycleDefsMap = new Map();
  
}

// read input config and execute other functions to show analysis
function analyzeFromConfig(){
  const button = document.getElementById('analyzebutton');

  if(button){
    const spawnCycle = getSelectedInfoById('spawncycle').selectedText;
    const gameLength = getSelectedInfoById('gamelength').selectedIndex;
    const difficulty = getSelectedInfoById('difficulty').selectedIndex;

    const wsfInput = document.getElementById('wavesizefakes');
    const wsf = (wsfInput)
      ? wsfInput.value
      : 12;
  
    const analysis = analyzeCycle(spawnCycle, gameLength, difficulty, wsf);
    updateAnalysis(analysis);
  }
  else{
    console.error("Not found the button identified as analyzebutton");
  }
}

// get the value of currently selected option
function getSelectedInfoById(id){
  const select = document.getElementById(id);

  if(!select){
    console.error(`Not found the select (id: ${id})`);
    return '';
  }

  if(select.options.length === 0){
    console.error(`Select (id: ${id}) has no option`);
    return '';
  }
  
  const selectedIndex = select.selectedIndex;
  const selectedOption = select.options[selectedIndex];
  const selectedText = selectedOption.textContent;
  return {
    selectedIndex,
    selectedText
  };  
}

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
}

function updateAnalysis(analysis){
  // update table content
}