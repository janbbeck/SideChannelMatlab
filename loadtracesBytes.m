tmp = importdata('traces/tracebytes0.bin',' ');
tracelength = size(tmp);
traces=zeros(200,tracelength(2)); % not strictly necessary, but speeds up memory access.
for i=0:199
  fileNameString = sprintf('traces/tracebytes%d.bin',i);
  traces(i+1,:) = importdata(fileNameString,' ');
end