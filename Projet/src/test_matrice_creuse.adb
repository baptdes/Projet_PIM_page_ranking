with ada.Text_IO; use ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;
with vecteurs;
with vecteurs.matrice_creuse;

procedure test_matrice_creuse is

    function est_nul(x : Float) return Boolean is
    begin
        return abs(x) < 0.000001;
    end est_nul;
    
    package vecteurs_float is new vecteurs(Capacite => 50, T_Valeur => Float);
    use vecteurs_float;

    package Matrice_creuse is new vecteurs_float.Matrice_creuse(Taille => 50, zero => 0.0,est_nul =>est_nul);
    use Matrice_creuse;

    procedure test_modifier_valeur is
        M1 : T_mat;
    begin
        Initialiser_matrice(2, 2, M1);

        Enregistrer(M1,1,1,1.0);
        Enregistrer(M1,1,2,2.0);
        Enregistrer(M1,2,1,3.0);
        Enregistrer(M1,2,2,4.0);

        Assert(Valeur(M1,1,1) = 1.0);
        Assert(Valeur(M1,1,2) = 2.0);
        Assert(Valeur(M1,2,1) = 3.0);
        Assert(Valeur(M1,2,2) = 4.0);

    end test_modifier_valeur;

    procedure test_multiplication is
        M1 : T_mat;
        M2 : T_mat;
        Mult : T_mat;
    begin
        Initialiser_matrice(2, 2, M1);
        Initialiser_matrice(2, 2, M2);

        Enregistrer(M1,1,1,1.0);
        Enregistrer(M1,1,2,2.0);
        Enregistrer(M1,2,1,3.0);
        Enregistrer(M1,2,2,4.0);

        Enregistrer(M2,1,1,1.0);
        Enregistrer(M2,1,2,2.0);
        Enregistrer(M2,2,1,3.0);
        Enregistrer(M2,2,2,4.0);

        Mult := M1 * M2;
        Assert(nb_lignes(Mult) = 2);
        Assert(nb_colones(Mult) = 2);
        Assert(Valeur(Mult,1,1) = 7.0);
        Assert(Valeur(Mult,1,2) = 10.0);
        Assert(Valeur(Mult,2,1) = 15.0);
        Assert(Valeur(Mult,2,2) = 22.0);

    end test_multiplication;
    
    procedure test_addition is
        M1: T_mat;
        M2: T_mat;
        M3: T_mat;
    begin
        Initialiser_matrice(2, 2, M1);
        Initialiser_matrice(2, 2, M2);
        
        Enregistrer(M1,1,1,1.0);
        Enregistrer(M1,1,2,2.0);
        Enregistrer(M1,2,1,3.0);
        Enregistrer(M1,2,2,4.0);

        Enregistrer(M2,1,1,1.0);
        Enregistrer(M2,1,2,2.0);
        Enregistrer(M2,2,1,3.0);
        Enregistrer(M2,2,2,4.0);
        
        M3 := M1 + M2;
        Assert(Valeur(M3,1,1) = 2.0);
        Assert(Valeur(M3,1,2) = 4.0);
        Assert(Valeur(M3,2,1) = 6.0);
        Assert(Valeur(M3,2,2) = 8.0);
    end test_addition;

    
begin
    Put_Line("Début test matrices creuses");
    Put_Line("--------------------------------------");
    test_modifier_valeur;
    Put_Line("Test modifier_valeur OK");
    test_multiplication;
    Put_Line("Test multiplacation matricielle OK");
    test_addition;
    Put_Line("Test addition matrices OK");
    Put_Line("--------------------------------------");
    Put_Line("Fin test matrices creuses");
end;