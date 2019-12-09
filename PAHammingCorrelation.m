
% declaration of the SBOX (might be useful to calculate the power hypothesis)
SBOX=[099 124 119 123 242 107 111 197 048 001 103 043 254 215 171 118 ...
      202 130 201 125 250 089 071 240 173 212 162 175 156 164 114 192 ...
      183 253 147 038 054 063 247 204 052 165 229 241 113 216 049 021 ...
      004 199 035 195 024 150 005 154 007 018 128 226 235 039 178 117 ...
      009 131 044 026 027 110 090 160 082 059 214 179 041 227 047 132 ...
      083 209 000 237 032 252 177 091 106 203 190 057 074 076 088 207 ...
      208 239 170 251 067 077 051 133 069 249 002 127 080 060 159 168 ...
      081 163 064 143 146 157 056 245 188 182 218 033 016 255 243 210 ...
      205 012 019 236 095 151 068 023 196 167 126 061 100 093 025 115 ...
      096 129 079 220 034 042 144 136 070 238 184 020 222 094 011 219 ...
      224 050 058 010 073 006 036 092 194 211 172 098 145 149 228 121 ...
      231 200 055 109 141 213 078 169 108 086 244 234 101 122 174 008 ...
      186 120 037 046 028 166 180 198 232 221 116 031 075 189 139 138 ...
      112 062 181 102 072 003 246 014 097 053 087 185 134 193 029 158 ...
      225 248 152 017 105 217 142 148 155 030 135 233 206 085 040 223 ...
      140 161 137 013 191 230 066 104 065 153 045 015 176 084 187 022];

%%%%%%%%%%%%%%%%%%%%
% LOADING the DATA %
%%%%%%%%%%%%%%%%%%%%
numberOfTraces = 200;
traceSize = 370000;
       
numberOfKeyBytes = 16;
myfile=fopen('plaintext-00112233445566778899aabbccddeeff.txt','r');
for i=1:numberOfTraces
	s = fgets(myfile, 1024);
	[ii, l]=sscanf(s, '%02x ', numberOfKeyBytes);
	plaintext(i,:)=ii;
end
fclose(myfile);

offset = 50000;        % we can limit the amount of data to be processed. Not strictly necessary
segmentLength = 40000; % we can limit amount of data to be processed. Not strictly necessary
myfile=fopen('traces-00112233445566778899aabbccddeeff.bin','r');
traces=zeros(200,segmentLength); % not strictly necessary, but speeds up memory access.
for i=1:200            % for each of the 200 traces
	fseek(myfile, offset, 'cof');
    if (segmentLength+offset > traceSize)
        t=fread(myfile, segmentLength-offset, 'uint8');
    else 
        t=fread(myfile, segmentLength, 'uint8');
    end;
	fseek(myfile, (traceSize-segmentLength-offset), 'cof');
	traces(i,:)=t;  % add t to an array of traces, called 'traces'
end
fclose(myfile);

for currentKeyByte=1:16   % for every byte in the key
    currentKeyByte
    for currentKeyByteGuess = 0:255     % iterate through all candidate key bytes, 0x00 to 0xff                       
        currentKeyByteGuess
        xorResult = bitxor(plaintext(:,currentKeyByte),currentKeyByteGuess); % first operation is an XOR between the cleartext and the guessed key
        sboxLookup = SBOX(xorResult+1);     
        prediction = sum( dec2bin(sboxLookup).' == '1' );       % calculate Hamming Weight prediction
        for currentTimeIndex=1:segmentLength
          dataPoints = traces(:,currentTimeIndex);              % the data points for all the traces at the current time index 
          % lets see how well the data points match with the predicted hamming weights
          % by calculating the Pearson Correlation Coefficient for the current data point
          % we want the maximum correlation, positive or negative, so we take the absolute value
          varDataPoints=var(dataPoints);
          if (varDataPoints != 0)
            pearsonCorrelation(currentKeyByte,currentKeyByteGuess+1,currentTimeIndex) = abs(cov(dataPoints,prediction)/(sqrt(varDataPoints) * sqrt(var(prediction))));
          else
            pearsonCorrelation(currentKeyByte,currentKeyByteGuess+1,currentTimeIndex) = 0;
          end;
        end;
        F = squeeze(pearsonCorrelation(currentKeyByte,:,:));
        [X, Y] = find(F==max(F(:)));
        printf('Best match so far for byte %d: %d 0x%x\n',currentKeyByte, X(1)-1,X(1)-1)
    end;
    F = squeeze(pearsonCorrelation(currentKeyByte,:,:));  % fix dimensionality of array
    [bestMatch, bestMatchTimeIndex] = find(F==max(F(:))); % find highest correlation 
    solvedKey(currentKeyByte) = bestMatch(1) - 1;
    solvedKey
    fprintf('%x ', solvedKey);
    fprintf('\n');
end;
solvedKey
fprintf('%x ', solvedKey);
fprintf('\n');