/** @noSelfInFile */

declare namespace fs {
  /**
   * @noSelf
   */
  interface File {
    /**
     * @noSelf
     */
    write: (input: string) => void;
    close: () => void;
  }

  function open(name: string, type: 'w' | 'a' | 'r'): File;
}
