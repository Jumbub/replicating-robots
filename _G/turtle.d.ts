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
  function craft(quantity: number): boolean;
  function forward(): boolean;
  function back(): boolean;
  function up(): boolean;
  function down(): boolean;
  function turnLeft(): boolean;
  function turnRight(): boolean;
  function select(slotNum: number): boolean;
  function getSelectedSlot(): number;
  function getItemCount(slotNum?: number): number;
  function getItemSpace(slotNum?: number): number;
  function getItemDetail(
    slotNum?: number,
  ): {
    count: number;
    name: 'minecraft:oak_log';
  } | null;
  function equipLeft(): boolean;
  function equipRight(): boolean;
  function attack(toolSide?: string): boolean;
  function attackUp(toolSide?: string): boolean;
  function attackDown(toolSide?: string): boolean;
  function dig(toolSide?: string): boolean;
  function digUp(toolSide?: string): boolean;
  function digDown(toolSide?: string): boolean;
  function place(signText?: string): boolean;
  function placeUp(): boolean;
  function placeDown(): boolean;
  function detect(): boolean;
  function detectUp(): boolean;
  function detectDown(): boolean;
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
  function compare(): boolean;
  function compareUp(): boolean;
  function compareDown(): boolean;
  function compareTo(slot: number): boolean;
  function drop(count?: number): boolean;
  function dropUp(count?: number): boolean;
  function dropDown(count?: number): boolean;
  function suck(amount?: number): boolean;
  function suckUp(amount?: number): boolean;
  function suckDown(amount?: number): boolean;
  function refuel(quantity?: number): boolean;
  function getFuelLevel(): number;
  function getFuelLimit(): number;
  function transferTo(slot: number, quantity?: number): boolean;
}
