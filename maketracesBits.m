% print shell script to make trace files
fileID = fopen('tracescript.sh','w');
for i=0:199
  clearTextVector = (0:15) + mod(i,241); %create a vector of clear text bytes to encrypt
  commandString = sprintf('Tracer -o traces/tracebits%d.bin -t bits -- ./tiny-AES-c/AES_ECB.elf ',i);
  commandString = strcat(commandString, sprintf(' %x',clearTextVector)); % run whitebox with vector
  commandString = strcat(commandString, sprintf('\n')) % newline between commands
  fprintf(fileID, '%s', commandString);
end
fclose(fileID);

