const utils = require('./utils');

// dummy jest XD
let passCount = 0, failCount = 0;
let bAllSuccess = true;

describe("calcWaveSize", () => {
  it("(2, 2, 3, 12)", () => {
    const actually = utils.calcWaveSize(2, 2, 3, 12);
    const expected = 314;
    expect(actually).toBe(expected);
  });
});

describe("analyzeWave", () => {
  it("should parse correctly", () => {
    const waveDef = '3GF*_2FP!,1CY_10CR';
    const waveSize = 314;
    const expectedOutput = {
      'Gorefiend': 60,
      'Fleshpound': 40,
      'Cyst': 20,
      'Crawler': 194
    };
    expect(utils.analyzeWave(waveDef, waveSize)).toEqual(expectedOutput);
  });
});

function describe(description, testSuite){
  console.log('---------------------------------------------------');
  console.log(description);
  testSuite();
  
  console.log(`\t${passCount} passed\t${failCount} failed\n`);
  if(failCount > 0){
    bAllSuccess = false;
  }
  passCount = 0;
  failCount = 0;
}

function it(description, test){
  test();
  process.stdout.write(`  ${description}\n`);
}

function expect(expection){
  // processes to be executed after judging correctness
  const processBasedOnResult = (bCorrectlyExpected, destination) => {
    if(bCorrectlyExpected){
      process.stdout.write('\t\u2714');
      ++passCount;
    }
    else{
      process.stdout.write('\t');
      console.log(expection);
      console.log(`\tis expected to be`);
      process.stdout.write('\t');
      console.log(destination);
      process.stdout.write('\t\u2716');
      ++failCount;
    }
  };

  // complete corresponding
  const toBe = (destination) => {
    processBasedOnResult(expection === destination, destination);
  };

  // for array and object
  const toEqual = (destination) => {
    if(Array.isArray(destination)){

    }
    else if(typeof destination === 'object'){
      processBasedOnResult(deepEqual(expection, destination), destination);
    }
    else{
      console.error("Unexpected destination");
    }
  };

  return {
    toBe,
    toEqual
  };
}

function deepEqual(obj1, obj2){
  // complete corresponding
  if(obj1 === obj2){
    return true;
  }

  // keys
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);

  // difference length of keys means unmatch of objects
  if(keys1.length !== keys2.length || keys1.length === 0){
    return false;
  }

  // compare
  for(let key of keys1){
    if(!keys2.includes(key) || !deepEqual(obj1[key], obj2[key])){
      return false;
    }
  }
  return true;
}

console.log(
  bAllSuccess
    ? '\u2714  All tests passed successfully.'
    : '\u2716  Some tests failed.'
);
console.log('---------------------------------------------------');