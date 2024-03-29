
/- Problem 1: Append and Reverse -/

/- Prove the following theorems. If you can't complete a proof, 
you can use the tactic `sorry` for any part that you are 
unable to complete. -/

/- Note that we again define our own append reverse, 
this time using the built in types -/

-- part p1
def app : List Nat -> List Nat -> List Nat
  | List.nil,       bs => bs
  | List.cons a as, bs => List.cons a (app as bs)

def rev : List Nat -> List Nat 
  | List.nil => List.nil
  | List.cons a L => app (rev L) (List.cons a List.nil) 

-- 6 lines
theorem app_nil : forall (l : List Nat), app l [] = l := 
  by sorry

-- 6 lines
theorem app_assoc : forall (l1 l2 l3 : List Nat),
  app (app l1 l2) l3 = app l1 (app l2 l3) := 
 by sorry

-- 8 lines
theorem rev_app_distr: forall l1 l2 : List Nat,
  rev (app l1 l2) = app (rev l2) (rev l1) := 
 by sorry

-- 8 lines
theorem rev_involutive : forall l : List Nat,
  rev (rev l) = l := 
 by sorry
-- part p1


/- Problem 2: Evenness (and Relations) -/

/- Prove the following theorems. If you can't complete a proof, 
you can use the tactic `sorry` for any part that you are 
unable to complete. -/

-- part p2
inductive ev : Nat -> Prop 
| O : ev 0
| SS (n : Nat) (H : ev n) : ev (Nat.succ (Nat.succ n))

def double : Nat -> Nat
| 0 => 0
| Nat.succ n => Nat.succ (Nat.succ (double n))

-- 5 lines
theorem ev_double : forall n, ev (double n) := 
 by sorry

-- 15 lines
theorem ev_sum : forall n m, ev n -> ev m -> ev (Nat.add n m) := 
 by sorry

-- 3 lines
theorem three_not_ev : Not (ev 3) := 
 by sorry

inductive ev' : Nat -> Prop :=
  | O : ev' 0
  | SSO : ev' 2
  | sum n m (Hn : ev' n) (Hm : ev' m) : ev' (Nat.add n m)

-- 21 lines
theorem ev'_ev : forall n, ev' n <-> ev n := 
 by sorry

-- part p2

/- Problem 3: Subsequences -/

/- Prove the following theorems. If you can't complete a proof, 
you can use the tactic `sorry` for any part that you are 
unable to complete. -/

-- part p3
inductive subseq : List Nat -> List Nat -> Prop
| empty : subseq [] []
| include x l1 l2 (H : subseq l1 l2) : subseq (x::l1) (x::l2)
| skip x l1 l2 (H : subseq l1 l2) : subseq l1 (x::l2)

-- 6 lines
theorem subseq_refl : forall (l : List Nat), 
  subseq l l :=
 by sorry

-- 5 lines
theorem subseq_empty : forall l, subseq [] l := 
 by sorry

-- 13 lines
theorem subseq_app : forall (l1 l2 l3 : List Nat),
  subseq l1 l2 ->
  subseq l1 (List.append l2 l3) :=
 by sorry
-- part p3

/- Problem 4: Insertion Sort -/


/- Prove the following theorems. If you can't complete a proof, 
you can use the tactic `sorry` for any part that you are 
unable to complete. -/

-- part p4
def insert : Nat -> List Nat -> List Nat
| y, [] => [y]
| y, x::xs => if Nat.ble y x 
              then y :: x :: xs 
              else x :: insert y xs

def isort : List Nat -> List Nat
| []      => []
| x :: xs => insert x (isort xs) 

inductive All : {T : Type} -> (T -> Prop) -> List T -> Prop
| nil : All P []
| cons : forall x L, P x -> All P L -> All P (x :: L)

inductive Sorted : List Nat -> Prop
| nil : Sorted []
| cons : forall n l, Sorted l -> 
                     All (Nat.le n) l ->
                     Sorted (n :: l)


theorem all_trans : forall (P : T -> Prop) (Q : T -> Prop) L,
  All P L ->
  (forall x, P x -> Q x) ->
  All Q L := 
 by intros P Q L Hall PtoQ
    induction Hall
    case nil => constructor
    case cons P x L Px HL =>
      constructor
      apply PtoQ
      assumption
      assumption

-- 23 lines
theorem insert_le : forall n x l,
  All (Nat.le n) l ->
  Nat.le n x ->
  All (Nat.le n) (insert x l) := 
 by sorry


theorem ble_inv : forall a b, 
                  Nat.ble a b = false
               -> Nat.ble b a = true := 
 by intros a b H
    rw [Nat.ble_eq]
    cases (Nat.le_total b a)
    assumption
    rw [<- Nat.not_lt_eq]
    rw [<- Bool.not_eq_true] at H
    rw [Nat.ble_eq] at H
    contradiction

-- 37 lines
theorem insert_sorted : forall x l, 
  Sorted l ->
  Sorted (insert x l) := 
 by sorry

-- 8 lines
theorem isort_sorted : forall l, Sorted (isort l) :=
 by sorry

inductive Permutation : {T : Type} -> List T -> List T -> Prop
| nil   : Permutation [] []
| skip  : forall (x : A) (l l' : List A),
          Permutation l l' ->
          Permutation (x :: l) (x :: l')
| swap  : forall (x y : A) (l : List A),
          Permutation (y :: x :: l) (x :: y :: l)
| trans : forall l l' l'' : List A,
          Permutation l l' ->
          Permutation l' l'' ->
          Permutation l l''

example : Permutation [true,true,false] [false,true,true] :=
 by apply Permutation.trans (l' := [true,false,true])
    . apply Permutation.skip
      apply Permutation.swap
    . apply Permutation.swap

-- 6 lines
theorem perm_refl : forall {T : Type} (l : List T), 
  Permutation l l := 
 by sorry

-- 10 lines
theorem perm_length : forall {T : Type} (l1 l2 : List T), 
  Permutation l1 l2 -> l1.length = l2.length :=
 by sorry

-- 12 lines
theorem perm_sym : forall {T : Type} (l1 l2 : List T), 
  Permutation l1 l2 -> Permutation l2 l1 :=
 by sorry

-- 18 lines
theorem insert_perm : forall x l, 
  Permutation (x :: l) (insert x l) :=
 by sorry

-- 10 lines
theorem isort_perm : forall l, Permutation l (isort l) :=
 by sorry

-- part p4