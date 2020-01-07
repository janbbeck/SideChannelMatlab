for i=0:199
  fileNameString = sprintf('traces/tracebits%d.bin',i);
  tracefile = fopen(fileNameString,'r');
  traces(i+1,:) = fread(tracefile, 'int8');
  fclose(tracefile);
end