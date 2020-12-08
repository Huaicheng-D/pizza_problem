% Pizza Problem

int: n;  %the number of pizzas
int: m;  %the number of coupons

set of int: pizza_id = 1..n;  % the ID of pizza, used for mapping to price
array[pizza_id] of int: price;   % the price of each pizza

set of int: coupon_id = 1..m; % the ID of coupons, used for mapping to buy and free
array[coupon_id] of int: buy; % the number of paid pizzas required to justify using each coupon
array[coupon_id] of int: free; % the number of free pizzas can be obtained by each coupon

int: k; % Cost bound

var set of pizza_id: Paid;  % the set of pizza will be paid for
var set of coupon_id: Used;  % the set of coupon will be used for

array[coupon_id, pizza_id] of var bool: Justifies; % the pizza_id is the one we paid for to justify using coupon_id
array[coupon_id, pizza_id] of var bool: UsedFor; % the pizza_id is the free pizza we got from using coupon_id


% Property #1: We pay for exactly the pizzas we don't get from the coupons
constraint forall(p in pizza_id)((p in Paid) <-> not( exists(c in Used)(UsedFor[c,p])));

% Property #2: Used is the set of coupons we use:
constraint forall(c in coupon_id)((c in Used) <-> (exists(p in pizza_id)(UsedFor[c,p])));

% Property #3: Any coupon that is used must be justified by the amount of paid pizzas
constraint forall(c in coupon_id)((c in Used) -> (sum(p in Paid)(bool2int( Justifies[c,p]))) >= buy[c]);

% Property #4: The number of any coupon is used for can only obtain at most free[c] pizzas
constraint forall(c in Used)((sum(p in pizza_id)(bool2int(UsedFor[c,p]))) <= free[c]);

% Property #5: Each free pizza should be at most as much as cheap as the cheapest pizza used to justify the coupon
constraint forall(c in coupon_id, p1, p2 in pizza_id where p1 != p2)(
                               ((UsedFor[c,p1]) /\ (Justifies[c,p2])) -> (price[p1] <= price[p2]));

% Property #6: Pay for every pizza used to justify coupon
constraint forall(p in pizza_id, c in coupon_id)((Justifies[c,p]) -> (p in Paid));

% Property #7: The total cost is not too large
constraint sum(p in Paid)(price[p]) <= k;

% Property #8: Make sure the number of justifies and usedfor hold for the truth
constraint forall(c in coupon_id, p in pizza_id)((Justifies[c,p]) -> 
                                                  ((1 <= c /\ c <= m) /\ (1<= p) /\ (p <=n)));
constraint forall(c in coupon_id, p in pizza_id)((UsedFor[c,p]) ->
                                                  ((1 <= c /\ c <= m) /\ (1<= p) /\ (p <=n)));
% Property #9: 
%constraint forall(c in coupon_id)(forall(p in pizza_id)(Justifies[c,p] -> not exists(v in coupon_id where c != v) (Justifies[v,p])));

var int: total_cost = sum(p in pizza_id)(bool2int(p in Paid) * price[p]);

solve minimize total_cost;

output  [show(total_cost)];