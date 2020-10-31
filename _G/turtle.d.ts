/** @noSelfInFile */

declare type InspectResult = [
  boolean,
  (
    | {
        name: string;
        tags: {
          'minecraft:logs'?: boolean;
        };
      }
    | 'No block to inspect'
  ),
];

declare namespace turtle {
  function up(): boolean;
  function down(): boolean;
  function forward(): boolean;
  function back(): boolean;
  function turnLeft(): boolean;
  function turnRight(): boolean;
  function dig(): boolean;
  function digUp(): boolean;
  function digDown(): boolean;
  /**
   * @tupleReturn
   */
  function inspect(): InspectResult;
  /**
   * @tupleReturn
   */
  function inspectUp(): InspectResult;
  /**
   * @tupleReturn
   */
  function inspectDown(): InspectResult;
  function getFuelLevel(): number;
}
