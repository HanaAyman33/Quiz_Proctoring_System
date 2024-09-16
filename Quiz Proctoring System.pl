% Codes for each day
code(sat,0).
code(sun,1).
code(mon,2).
code(tue,3).
code(wed,4).
code(thu,5).

%--------------------------------------1st predicate---------------------------------------

assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule):-
    free_schedule(AllTAs , TeachingSchedule, FreeSchedule),!,
    assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule).

%--------------------------------------2nd predicate---------------------------------------

free_schedule(AllTAs , TeachingSchedule , FreeSchedule):-
    free_schedule_helper(AllTAs , 0 , TeachingSchedule , FreeSchedule).

free_schedule_helper(_,6,_,[]).
free_schedule_helper(AllTAs,Day_Code,TeachingSchedule, FreeSchedule):-
    code(Day,Day_Code),
    FreeSchedule = [HF|TF],
    get_free_TAs(AllTAs,TeachingSchedule,Day,1,Count,S1),
    get_free_TAs(AllTAs,TeachingSchedule,Day,2,Count,S2),
    get_free_TAs(AllTAs,TeachingSchedule,Day,3,Count,S3),
    get_free_TAs(AllTAs,TeachingSchedule,Day,4,Count,S4),
    get_free_TAs(AllTAs,TeachingSchedule,Day,5,Count,S5),
    HF = day(Day,[S1,S2,S3,S4,S5]),
    Day_Code1 is Day_Code+1,
    free_schedule_helper(AllTAs,Day_Code1,TeachingSchedule,TF).

get_free_TAs(AllTAs,TeachingSchedule,Day,Slot,Count,Final_Result):-
    get_busy_TAs(AllTAs,TeachingSchedule,Day,Slot,Count,Busy_TAs),      
    get_free_helper(AllTAs,Busy_TAs,FreeTAs), 				% free TAs at a specific Day & Slot
    permutation(FreeTAs,Final_Result).

get_busy_TAs(AllTAs,TeachingSchedule,Day,Slot,_,Busy_TAs):-
    get_teaching_TAs(TeachingSchedule,Day,Slot,Teaching_TAs),
    get_dayOff_TAs(AllTAs,Day,DayOff_TAs),
    append(DayOff_TAs,Teaching_TAs,Busy_TAs).

get_dayOff_TAs([],_,[]).
get_dayOff_TAs(AllTAs,Day,DayOff_TAs):-
    AllTAs = [ta(Name, Day)|T1],
    DayOff_TAs = [Name|T2],
    get_dayOff_TAs(T1,Day,T2).

get_dayOff_TAs(AllTAs,Day,DayOff_TAs):-
    AllTAs = [ta(_, Day2)|T1],
    Day\=Day2,
    get_dayOff_TAs(T1,Day,DayOff_TAs).

get_teaching_TAs(TeachingSchedule,Day,Slot,Teaching_TAs):-
    code(Day,I),
    nth0(I,TeachingSchedule,day(_,Slots_List)),
    nth1(Slot,Slots_List,Teaching_TAs).

get_free_helper([],_,[]).
get_free_helper(AllTAs,Busy_TAs,Final_Result):-
    AllTAs = [ta(Name, _)|T],
    member(Name,Busy_TAs),
    get_free_helper(T,Busy_TAs,Final_Result).
get_free_helper(AllTAs,Busy_TAs,Final_Result):-
    AllTAs = [ta(Name, _)|T],
    \+member(Name,Busy_TAs),
    Final_Result = [Name|TF],
    get_free_helper(T,Busy_TAs,TF).

%-------------------------------------3rd predicate----------------------------------------

assign_quizzes([],_,[]).
assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule):- 
    Quizzes = [Quiz|T],
    Quiz = quiz(_, Day, Slot, _),
    code(Day,I),
    nth0(I,FreeSchedule,day(_,Slots_List)),
    nth1(Slot,Slots_List,Free_TAs),
    assign_quiz(Quiz, FreeSchedule, AssignedTAs),
    delete_list(AssignedTAs,Free_TAs,Rest_Of_Free), 				% Rest_Of_Free -> New FreeTAs List after Removing the assigned TAs to the current Quiz		
    edit_free_schedule(FreeSchedule,Rest_Of_Free,Day,Slot,Edited_Free_Schedule),		
    ProctoringSchedule = [HP|TP],
    HP = proctors(Quiz, AssignedTAs),
    assign_quizzes(T,Edited_Free_Schedule,TP).

delete_list([],Result,Result).
delete_list(AssignedTAs,Free_TAs,Result):-	% Remove the assigned TAs and get the rest of free TAs
    AssignedTAs = [H|T],
    delete(Free_TAs,H,Tmp),
    delete_list(T,Tmp,Result).

edit_free_schedule([],_,_,_,[]).
edit_free_schedule(FreeSchedule,Rest_Of_Free,Day,Slot,Result):-
    FreeSchedule = [HR|T],
    HR=day(Day1,_),
    Day1\=Day,
    Result = [HR|TR],
    edit_free_schedule(T,Rest_Of_Free,Day,Slot,TR).
edit_free_schedule(FreeSchedule,Rest_Of_Free,Day,Slot,Result):-
    FreeSchedule = [H|T],
    H = day(Day,Slots_List),
    edit_slots(Slots_List,1,Slot,Rest_Of_Free,Edited_Slots),
    Result = [HR|TR],
    HR = day(Day,Edited_Slots),
    edit_free_schedule(T,Rest_Of_Free,Day,Slot,TR).

edit_slots([],_,_,_,[]).
edit_slots(Slots_List,Counter,Slot,Rest_Of_Free,Result):-	% Target slot
    Counter = Slot,
    Slots_List = [_|S],
    Result = [Rest_Of_Free|TR],
    Counter1 is Counter+1,
    edit_slots(S,Counter1,Slot,Rest_Of_Free,TR).
edit_slots(Slots_List,Counter,Slot,Rest_Of_Free,Result):-
    Counter \= Slot,
    Slots_List = [H|TS],
    Result = [H|TR],
    Counter1 is Counter+1,
    edit_slots(TS,Counter1,Slot,Rest_Of_Free,TR).

%-----------------------------------4th predicate------------------------------------------

assign_quiz(Quiz, FreeSchedule, AssignedTAs):-
    Quiz = quiz(_, Day, Slot, Count),
    code(Day,I),
    nth0(I,FreeSchedule,day(_,Slots_List)),
    nth1(Slot,Slots_List,Free_TAs),
    length(Free_TAs,Length),
    Length >= Count,
    get_sublist(Count,Free_TAs,AssignedTAs).

get_sublist(Count,List,Res):-
    get_sublist_helper(List,Z),
    length(Z,Count),
    permutation(Z,Res).

get_sublist_helper([],[]).
get_sublist_helper([X|Tx],[X|Ty]):-   % Take
    get_sublist_helper(Tx,Ty).
get_sublist_helper([_|Tx],Y):-	      % Leave
    get_sublist_helper(Tx,Y).
