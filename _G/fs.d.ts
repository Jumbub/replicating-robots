/** @noSelfInFile */

declare namespace fs {
  interface File {
    write: (input: string) => void;
    close: () => void;
  }

  function open(name: string, type: 'w' | 'a' | 'r'): File;
}
