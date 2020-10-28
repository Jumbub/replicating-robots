/** @noSelfInFile */

declare namespace turtle {
  function forward(n?: number): boolean;
  function dig(): boolean;
  function digUp(): boolean;
  /**
   * @tupleReturn
   */
  function inspect(n?: number): [boolean, { name: string }];
  /**
   * @tupleReturn
   */
  function inspectUp(n?: number): [boolean, { name: string }];
  function getFuelLevel(): number;
}
