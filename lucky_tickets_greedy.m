% Code accompanying the article preprint "Revisiting Lucky Tickets: Teaching 
% Combinatorics in the Classroom"
% October 2024
% Bismark Singh
% b.singh@southampton.ac.uk


% A greedy algorithm to quickly compute the next/close enough SLT
% Accuracy is about 31%


%% Computing the next SLT given ticket abcdef

function out = is_slt(a,b,c,d,e,f)
% is_slt checks if ticket abcdef is slt; returns true if SLT returns FALSE if not

number = [a,b,c,d,e,f];
[unique_values,~] = unique(number);
if a+b+c == d+e+f && numel(unique_values) ==6
    out = true;
else
    out = false;
end
end
count=0; count_larger=0;
for i=1:1000
    % First write the number as abcdef
    current = floor(999999*rand) ;
    old_current = current ;
    current = num2str(current, '%06d'); 

    a=str2double(current(1)); b=str2double(current(2)); c=str2double(current(3));
    d=str2double(current(4)); e=str2double(current(5)); f=str2double(current(6));
    current = [a,b,c,d,e,f];

    iter= 0; % iteration counter

    [unique_values,first_index] = unique(current) ; % unique_values are values of unique digits values and first_index is the first index of these unique values

    %% Make first three elements unique
    if numel(unique([a,b,c])) ~=6 % check if first 3 digits are unique
        while ~isempty(find([a,b]==c,1))  % check if c is not unique
            if c==9
                c=0; b=min(b+1,9) ;
            else
                c=min(c+1,9);
            end
        end

        while ~isempty(find([a,c]==b,1))  % check if b is not unique
            if b==9
                if a==9
                    disp('Algorithm failed or there is no larger SLT');
                    fprintf('Starting ticket = %s\n',old_current);
                    fprintf('Ending ticket = %d%d%d%d%d%d\n',a,b,c,d,e,f);
                    break
                end
                b=0; a=min(a+1,9) ;
            else
                b=min(b+1,9);
            end
        end
    end

    if numel(unique([a,b,c])) ==3
        disp('First phase: success');
        phase1_success = true ;
    else
        disp('First phase: failure');
        phase1_success = false ;
    end
[a b c d e f]
    left_sum = a+b+c;
    right_sum = d+e+f;

    %% Make sums equal beginning with f
    if left_sum ~=right_sum
        f= max(0,min(left_sum-d-e,9));
        right_sum= d+e+f;
    end
    if left_sum~=right_sum % first make sums equal
        e= max(0,min(left_sum-d-f,9));
        right_sum= d+e+f;
    end
    if left_sum~=right_sum
        d= max(0,min(left_sum-f-e,9));
    end
    if left_sum==right_sum
        disp('Second phase: success');
        phase2_success = true;
    else
        disp('Second phase: failure');
        phase2_success = false;
    end
[a b c d e f]
    %% Now, sums are equal, make d e f unique
    if  numel(unique([a,b,c,d,e,f])) ~=6
        while ~isempty(find([a,b,c,d,e]==f,1))  % enter the loop if f is not unique
            if e==9
                d=min(9,d+1); f=max(f-1,0);
            else
                e= min(9,e+1); f=max(f-1,0);
            end
            if f==0
                disp('Algorithm failed');
                break
            end
        end

        while ~isempty(find([a,b,c,d,f]==e,1))  % enter the loop if e is not unique
            if d==9
                e= min(9,e+1); f=max(f-1,0);
            else
                d= min(9,d+1); e=max(e-1,0);
            end
            if (d==9 && f==0)
                disp('Algorithm failed');
                break

            end
        end

    end

    if numel(unique([a,b,c,d,e,f])) ==6
        disp('Third phase: success');
    else
        disp('Third phase: failure');
    end

    %% collect output
    if ~is_slt(a,b,c,d,e,f)
        disp('Algorithm failed');
        fprintf('Starting ticket = %d\n',old_current);
        fprintf('Ending ticket = %d%d%d%d%d%d\n',a,b,c,d,e,f);
    else
        disp('Algorithm succeeded');
        fprintf('Starting ticket = %d\n',old_current);
        fprintf('Next ticket = %d%d%d%d%d%d\n',a,b,c,d,e,f);
        count=count+1;
        new_current=10^5*a+10^4*b+10^3*c+10^2*d+10*e+f;
        if new_current >=old_current
            count_larger=count_larger+1;
        end
    end
end
count
count_larger