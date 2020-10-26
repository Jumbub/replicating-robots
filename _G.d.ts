// Uses some declarations from
// https://www.lua.org/manual/5.1/manual.html
/**
 * A global variable (not a function) that holds a string containing the
 * current interpreter version.
 */
declare const _VERSION: number;
/**
 * Receives any number of arguments, and prints their values to stdout, using the
 * tostring function to convert them to strings. print is not intended for
 * formatted output, but only as a quick way to show a value, typically for
 * debugging. For formatted output, use string.format.
 * @param args Arguments to print
 */
declare function print(...args: any[]): void;

declare const turtle: {
  forward: (n?: number) => boolean;
  dig: () => boolean;
  /** !TupleReturn */
  inspect: (n?: number) => [boolean, { name: string }];
  getFuelLevel: () => number;
};
