%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab key recovery exercise template %
%                                       %
% 2014, Florent Bruguier, PCM - CNFM    %
% 2019, modified by Jan Beck            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% declaration of the SBOX
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


numberOfTraces = 200;
traceSize = max(size(traces(1,:)));
       
for i=0:(numberOfTraces-1)
  plaintext(i+1,:) = (0:15) + mod(i,241);
end

byteStart = 1;
byteEnd = 16;
keyCandidateStart = 0;
keyCandidateStop = 255;
solvedKey = zeros(1,byteEnd);

% for every byte in the key do:
for currentKeyByte=byteStart:byteEnd
    currentKeyByte
    for currentKeyByteGuess = keyCandidateStart:keyCandidateStop             % iterate through all candidate key bytes, 0x00 to 0xff                       
        currentKeyByteGuess
        xorResult = bitxor(plaintext(:,currentKeyByte),currentKeyByteGuess); % first operation is an XOR between the cleartext and the guessed key
        Hypothesis(:,currentKeyByteGuess+1)=SBOX(xorResult+1);               % then the XOR gets substituted +1 because MATlab index starts at 
        
        group1= zeros(1,traceSize);
        group2= zeros(1,traceSize);
        numberOfTracesInGroup1 = 0;
        numberOfTracesInGroup2 = 0;

        % for all traces put into one or other group based on predicted Least Significant Bit
        for L = 1:numberOfTraces
            firstByte = bitget(Hypothesis(L,currentKeyByteGuess+1),1);       % get the expected least significant bit from the hypothesis (you can change this to any other bit 1-8)
            if firstByte == 1
                group1(1,:) = group1(1,:) + traces(L,:);
                numberOfTracesInGroup1 = numberOfTracesInGroup1 + 1;
            else
                group2(1,:) = group2(1,:) + traces(L,:);
                numberOfTracesInGroup2 = numberOfTracesInGroup2 + 1;
            end;
        end;
        % Calculation of the average of the groups
        group1(1,:) = group1(1,:) / numberOfTracesInGroup1; % average of group 1
        group2(1,:) = group2(1,:) / numberOfTracesInGroup2; % average of group 2
        groupDifference = abs(group1(1,:)-group2(1,:)); % subtracting the averages and taking the absolute value. We are interested in the largest difference, positive or negative from average
        groupFin(currentKeyByteGuess+1,:) = groupDifference; % storing the difference trace based on the current key byte guess.
        maxDifference(currentKeyByteGuess+1) = max(groupDifference);
    end;
    % so now we have all the trace differences and we need to find the one that contains the largest value
    [traceDifferenceWithLargestValueX, traceDifferenceWithLargestValueY] = find(groupFin==max(groupFin(:)));
    solvedKey(1,currentKeyByte) = traceDifferenceWithLargestValueX(1) - 1;
    fprintf('%x ', solvedKey);
    fprintf('\n');
end;
solvedKey