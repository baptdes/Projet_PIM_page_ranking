with ada.Text_IO; use ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;
with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Matrice_creuse;

procedure test_matrice_creuse is
    
    package Matrice is new Matrice_creuse(Capacite => 50, Taille => 10);
    use Matrice;

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

    procedure test_modifier_ligne is
        M1: T_mat;
    begin
        Initialiser_matrice(2, 2, M1);
        Modifier_ligne(M1,1,3.0);
        Assert(Valeur(M1,1,1) = 3.0);
        Assert(Valeur(M1,1,2) = 3.0);
        Assert(Valeur(M1,2,1) = 0.0);
        Assert(Valeur(M1,2,2) = 0.0);
    end test_modifier_ligne;

    procedure test_multiplication_vecteur_matrice is
        M: T_mat;
        V : T_vecteur;
        Mult : T_vecteur;
    begin
        Initialiser_matrice(2, 2, M);
        Initialiser_vecteur(2,2.0,V);
        Modifier_ligne(M,1,3.0);
        Modifier_ligne(M,2,1.5);
        V.tab(2) := 5.0;
        Mult := V * M;

        Assert(Mult.tab(1) = 13.5);
        Assert(Mult.tab(2) = 13.5);
    end test_multiplication_vecteur_matrice;

    
begin
    Put_Line("Début test matrices creuses");
    Put_Line("--------------------------------------");
    test_modifier_valeur;
    Put_Line("Test modifier_valeur OK");
    test_multiplication;
    Put_Line("Test multiplacation matricielle OK");
    test_addition;
    Put_Line("Test addition matrices OK");
    test_modifier_ligne;
    Put_Line("Test modifier_ligne OK");
    test_multiplication_vecteur_matrice;
    Put_Line("Test multiplication vecteur matrice OK");
    Put_Line("--------------------------------------");
    Put_Line("Fin test matrices creuses");
end;