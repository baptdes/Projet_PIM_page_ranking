with ada.Text_IO; use ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;
with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with vecteurs;

procedure test_vecteurs is
    
    package vecteurs_float is new vecteurs(Capacite => 50, T_Valeur => Float);
    use vecteurs_float;

    function max is new vecteurs_float.max;
    function distance is new vecteurs_float.distance;
    
    procedure test_distance is
        V1: T_vecteur;
        V2: T_vecteur;
    begin
        Initialiser_vecteur(2, 0.0, V1);
        Initialiser_vecteur(2, 0.0, V2);
        Assert(distance(V1,V2) < 0.000001);
        
        V1.tab(1) := 1.0;
        V1.tab(2) := 4.0;
        V2.tab(1) := 2.0;
        V2.tab(2) := 7.0;
        Assert(abs(distance(V1,V2) - sqrt(10.0)) < 0.000001);
    end test_distance;
    
    procedure test_max is
        V: T_vecteur;
    begin
        Initialiser_vecteur(10, 0.0, V);
        V.tab(1) := 2.0;
        V.tab(4) := 3.0;
        Assert(max(V) = 4);
    end test_max;
    
begin
    Put_Line("Début tests vecteurs");
    Put_Line("--------------------------------------");
    test_distance;
    Put_Line("Test distance OK");
    test_max;
    Put_Line("Test ligne_max OK");
    Put_Line("--------------------------------------");
    Put_Line("Fin tests vecteurs");
end;