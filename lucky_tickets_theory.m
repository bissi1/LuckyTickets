% Code accompanying the article preprint "Revisiting Lucky Tickets: Teaching 
% Combinatorics in the Classroom"
% October 2024
% Bismark Singh
% b.singh@southampton.ac.uk

clc

% Define all empty counters
lucky_counter =0; lucky_value= zeros(27,1); lucky=zeros(999999,1);
luckyticket=[];
superlucky_counter =0; superlucky_value= zeros(27,1); superlucky=zeros(999999,1);
superluckyticket=[];
luckyprime_counter =0; luckyprime_value= zeros(27,1); luckyprime=zeros(999999,1);
luckyprimeticket=[];


%% Count all lucky numbers

for i=1:999999
    number = i;
    i = sprintf('%06d', i) ;
    number_string =num2str(i) ; left_string=number_string(1:3); right_string=number_string(4:6);
    left_sum = sum(left_string-'0');
    right_sum = sum(right_string-'0');

    if left_sum == right_sum
        luckyticket= [luckyticket,number] ;
        lucky_counter = lucky_counter+1;
        lucky(lucky_counter) = number ;
        % check how many values for each left_sum right_sum
        lucky_value(left_sum) = lucky_value(left_sum) + 1;
    end
end

%% Count all superlucky numbers

for i=1:999999
    number = i;
    i = sprintf( '%06d', i ) ;
    number_string =num2str(i) ; left_string=number_string(1:3); right_string=number_string(4:6);
    left_sum = sum(left_string-'0');
    right_sum = sum(right_string-'0');

    [~,num_unique,~] = unique(i) ;

    if left_sum == right_sum && numel(num_unique) ==6
        superluckyticket= [superluckyticket,number] ;
        superlucky_counter = superlucky_counter+1;
        superlucky(superlucky_counter) = number ;
        % check how many values for each left_sum right_sum
        superlucky_value(left_sum) = superlucky_value(left_sum) + 1;
    end
end

%% Count all lucky prime numbers

for i=1:999999
    number = i;
    i = sprintf( '%06d', i ) ;
    number_string =num2str(i) ; left_string=number_string(1:3); right_string=number_string(4:6);
    left_sum = sum(left_string-'0');
    right_sum = sum(right_string-'0');

    dummy       = char(num2cell(i));
    num_prime   =isprime(reshape(str2num(dummy),1,[])) ;

    if left_sum == right_sum && sum(num_prime) ==6
        luckyprimeticket=[luckyprimeticket,number];
        luckyprime_counter = luckyprime_counter+1;
        luckyprime(luckyprime_counter) = number ;
        % check how many values for each left_sum right_sum
        luckyprime_value(left_sum) = luckyprime_value(left_sum) + 1;
    end
end
%% End of script. Count miscellaneous results.
% All lucky, superlucky, luckyprime tickets are given by luckyticket, superluckyticket, and luckyprimeticket


% how many tickets to buy to ensure luckiness?
dum=zeros(numel(luckyticket),1);
for i=2:numel(luckyticket)
    dum(i) = luckyticket(i) - luckyticket(i-1);
end
dummy=max(dum);
fprintf('Minimum of %d tickets are needed to ensure a Lucky Ticket\n',dummy)
clear dum ;
% how many tickets to buy to ensure superluckiness?
for i=2:numel(superluckyticket)
    dum(i) = superluckyticket(i) - superluckyticket(i-1);
end
dummy=max(dum);
fprintf('Minimum of %d tickets are needed to ensure a Superlucky Ticket\n',dummy)
clear dum;
% how many tickets to buy to ensure primeluckiness?
for i=2:numel(luckyprimeticket)
    dum(i) = luckyprimeticket(i) - luckyprimeticket(i-1);
end
dummy=max(dum);
fprintf('Minimum of %d tickets are needed to ensure a LuckyPrime Ticket\n',dummy)

%% The next part computes results for Fig 3
runs = 50 ; % how many runs
increment = 10 ; % how much increment for testing
% Count how many tickets needed for next LT,SLT, LPT
probability_lucky= zeros(runs,1);probability_superlucky= zeros(runs,1);probability_luckyprime= zeros(runs,1);
success_lucky=zeros(999999,1); success_superlucky=zeros(999999,1); success_luckyprime=zeros(999999,1);
for k=1:runs
    N=increment*k ;% fix the N value
    for i=1:999999
        % RHS sums up numbers from i to i+N to check if there is a LT/SLT/LPT in it
        success_lucky(i)       = sum(ismember((i+1:i+N),luckyticket))      >0; 
        success_superlucky(i)  = sum(ismember((i+1:i+N),superluckyticket)) >0;
        success_luckyprime(i)  = sum(ismember((i+1:i+N),luckyprimeticket)) >0;
    end
    probability_lucky(k)      = sum(success_lucky)/999999;
    probability_superlucky(k) = sum(success_superlucky)/999999 ;
    probability_luckyprime(k) = sum(success_luckyprime)/999999 ;
    k
end

% Same analysis as above, but conditional on beginning with a LT/SLT/LPT:
% Count how many tickets needed for next LT,SLT, LPT
cond_probability_lucky= zeros(runs,1);cond_probability_superlucky= zeros(runs,1);cond_probability_luckyprime= zeros(runs,1);
cond_success_lucky=zeros(numel(luckyticket),1); cond_success_superlucky=zeros(numel(superluckyticket),1); cond_success_luckyprime=zeros(numel(luckyprimeticket),1);
for k=1:runs
    N=increment*k ;% fix the N value

    % RHS sums up numbers from immediately next ticket after this LT to next N
    % and check if there is a LT/SLT/LPT in it

    for i=1:numel(luckyticket)
        cond_success_lucky(i)       = sum(ismember((luckyticket(i)+1:1:luckyticket(i)+N),luckyticket))  > 0;
    end
    for i=1:numel(superluckyticket)
        cond_success_superlucky(i)  = sum(ismember((superluckyticket(i)+1:1:superluckyticket(i)+N),superluckyticket)) > 0;
    end
    for i=1:numel(luckyprimeticket)
        cond_success_luckyprime(i)  = sum(ismember((luckyprimeticket(i)+1:1:luckyprimeticket(i)+N),luckyprimeticket))  > 0;
    end
    cond_probability_lucky(k)      = sum(cond_success_lucky)/numel(luckyticket);
    cond_probability_superlucky(k) = sum(cond_success_superlucky)/numel(superluckyticket) ;
    cond_probability_luckyprime(k) = sum(cond_success_luckyprime)/numel(luckyprimeticket) ;
end

% Plots
hold on
plot(1:runs, probability_lucky,'-o','MarkerEdgeColor','red','color', 'red')
plot(1:runs, probability_superlucky,'-+','MarkerEdgeColor','red','color', 'red')
plot(1:runs, probability_luckyprime,'--','MarkerEdgeColor','red','color', 'red')
legend('Lucky','SuperLucky','LuckyPrime')
ylabel('Probability of success in next N tickets') 
xlabel('N') 
xticklabels({'10','20','30','40','50','60','70','80','90','100'})
hold off
figure
hold on
plot(1:runs, cond_probability_lucky,'-o','MarkerEdgeColor','blue','color', 'blue')
plot(1:runs, cond_probability_superlucky,'-+','MarkerEdgeColor','blue','color', 'blue')
plot(1:runs, cond_probability_luckyprime,'--','MarkerEdgeColor','blue','color', 'blue')
legend('Lucky','SuperLucky','LuckyPrime')
ylabel('Conditional probability of success in next N tickets') 
xlabel('N') 
xticklabels({'10','20','30','40','50','60','70','80','90','100'})
hold off
