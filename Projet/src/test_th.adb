with ada.Text_IO; use ada.Text_IO;
with ada.Float_Text_IO; use ada.Float_Text_IO;
with ada.Integer_Text_IO; use ada.Integer_Text_IO;
with Ada.Assertions; use Ada.Assertions;
with TH;

procedure test_th is

    function Fonction_hachage(taille: in Integer; Cle1: in Integer; Cle2: in Integer) return Integer is
    begin
        return (Cle1 + Cle2) mod taille;
    end Fonction_hachage;

    package Hachage is 
        new TH(Capacite => 20, T_Cle => Integer, T_Valeur => Float, fonction_hachage => Fonction_hachage);
    use Hachage;

    procedure test_egalite is
        c1 : T_Couple;
        c2 : T_Couple;
    begin
        Couplage(c1,4,8);
        Couplage(c2,4,8);
        if egale(c1,c2) then
            Put_line("Test égalité OK");
        else
            Put_line("Comment on est là ?");
        end if;
    end test_egalite;

    procedure test_enregistrer is
        th : T_TH;
    begin
        Initialiser(th);
        Enregistrer(th,1,1,2.0);
        Enregistrer(th,1,4,2.5);
        Enregistrer(th,4,1,4.0);
        Enregistrer(th,15,8,8.0);
        Assert(La_Valeur(th,1,1) = 2.0);
        Assert(La_Valeur(th,1,4) = 2.5);
        Put_line("Test enregistrer OK");
    end test_enregistrer;

begin
    Put_Line("Début tests_th");
    Put_Line("--------------------------------------");
    test_egalite;
    test_enregistrer;
    Put_Line("--------------------------------------");
    Put_Line("Fin tests_th");
end test_th;