const { fail } = require('assert');
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
    expect(utils.analyzeWave(waveDef, waveSize)).toBe(['3', 'GF', '*']);
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
  const toBe = (destination) => {
    if(expection === destination){
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
  }
  return {toBe};
}

console.log(
  bAllSuccess
    ? '\u2714  All tests passed successfully.'
    : '\u2716  Some tests failed.'
);
console.log('---------------------------------------------------');