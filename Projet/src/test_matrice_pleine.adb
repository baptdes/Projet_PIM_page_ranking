with ada.Text_IO; use ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;
with vecteurs;
with vecteurs.matrice_pleine;

procedure test_matrice_pleine is
    
    function est_nul(x : Float) return Boolean is
    begin
        return abs(x) < 0.000001;
    end est_nul;
    
    package vecteurs_float is new vecteurs(Capacite => 50, T_Valeur => Float);
    use vecteurs_float;

    package Matrice_pleine is new vecteurs_float.Matrice_pleine(Capacite => 50, zero => 0.0, est_nul =>est_nul);
    use Matrice_pleine;

    procedure test_multiplication is
        M1 : T_mat;
        M2 : T_mat;
        Mult : T_mat;
    begin
        Initialiser_matrice(2, 2, 0.0, M1);
        Initialiser_matrice(2, 2, 0.0, M2);

        M1.Mat(1,1) := 1.0;
        M1.Mat(1,2) := 2.0;
        M1.Mat(2,1) := 3.0;
        M1.Mat(2,2) := 4.0;

        M2.Mat(1,1) := 1.0;
        M2.Mat(1,2) := 2.0;
        M2.Mat(2,1) := 3.0;
        M2.Mat(2,2) := 4.0;

        Mult := M1 * M2;
        Assert(Mult.nombre_colonne = 2);
        Assert(Mult.nombre_ligne = 2);
        Assert(Mult.Mat(1,1) = 7.0);
        Assert(Mult.Mat(1,2) = 10.0);
        Assert(Mult.Mat(2,1) = 15.0);
        Assert(Mult.Mat(2,2) = 22.0);

    end test_multiplication;
    
    procedure test_addition is
        M1: T_mat;
        M2: T_mat;
        M3: T_mat;
    begin
        Initialiser_matrice(2, 2, 0.0, M1);
        Initialiser_matrice(2, 2, 0.0, M2);
        
        M1.Mat(1,1) := 1.0;
        M1.Mat(1,2) := 2.0;
        M1.Mat(2,1) := 3.0;
        M1.Mat(2,2) := 4.0;

        M2.Mat(1,1) := 1.0;
        M2.Mat(1,2) := 2.0;
        M2.Mat(2,1) := 3.0;
        M2.Mat(2,2) := 4.0;
        
        M3 := M1 + M2;
        Assert(M3.Mat(1,1) = 2.0);
        Assert(M3.Mat(1,2) = 4.0);
        Assert(M3.Mat(2,1) = 6.0);
        Assert(M3.Mat(2,2) = 8.0);
    end test_addition;
    
    procedure test_modifier_ligne is
        M1: T_mat;
    begin
        Initialiser_matrice(2, 2, 0.0, M1);
        Modifier_ligne(M1,1,3.0);
        Assert(M1.Mat(1,1) = 3.0);
        Assert(M1.Mat(1,2) = 3.0);
        Assert(M1.Mat(2,1) = 0.0);
        Assert(M1.Mat(2,2) = 0.0);
    end test_modifier_ligne;
    
begin
    Put_Line("Début tests matrices pleines");
    Put_Line("--------------------------------------");
    test_multiplication;
    Put_Line("Test multiplacation matricielle OK");
    test_addition;
    Put_Line("Test addition matrices OK");
    test_modifier_ligne;
    Put_Line("Test modifier_ligne OK");
    Put_Line("--------------------------------------");
    Put_Line("Fin tests matrices pleines");
end;