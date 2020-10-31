export const loggerFactory = () => {
  const logger: {
    write: (input: string, color: string) => void;
    print?: (input: string, color: string) => void;
  } = {
    write: (input: string, color: string) => {
      term.setTextColor(getColor(color));
      write(input);
      term.setTextColor(getColor('white'));

      const logs = fs.open('logs', 'a');
      logs.write(input);
      logs.close();
    },
  };
  logger.print = (input: string, color: string) => logger.write(input + '\n', color);
  if (isLogger(logger)) {
    return logger;
  } else {
    throw 'never';
  }
};

const isLogger = (logger: {
  write: (input: string, color: string) => void;
  print?: (input: string, color: string) => void;
}): logger is {
  write: (input: string, color: string) => void;
  print: (input: string, color: string) => void;
} => !!logger.print;

const getColor = (color: string | undefined) => {
  if (color == 'white') {
    return colors.white;
  } else if (color == 'orange') {
    return colors.orange;
  } else if (color == 'magenta') {
    return colors.magenta;
  } else if (color == 'lightBlue') {
    return colors.lightBlue;
  } else if (color == 'yellow') {
    return colors.yellow;
  } else if (color == 'lime') {
    return colors.lime;
  } else if (color == 'pink') {
    return colors.pink;
  } else if (color == 'gray') {
    return colors.gray;
  } else if (color == 'lightGray') {
    return colors.lightGray;
  } else if (color == 'cyan') {
    return colors.cyan;
  } else if (color == 'purple') {
    return colors.purple;
  } else if (color == 'blue') {
    return colors.blue;
  } else if (color == 'brown') {
    return colors.brown;
  } else if (color == 'green') {
    return colors.green;
  } else if (color == 'red') {
    return colors.red;
  } else if (color == 'black') {
    return colors.black;
  }
  return colors.white;
};
