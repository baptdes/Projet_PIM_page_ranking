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

    procedure test_enregistrer is
        th : T_TH;
    begin
        Initialiser(th);
        Enregistrer(th,1,1,2.0);
        Enregistrer(th,1,4,2.5);
        Enregistrer(th,4,1,4.0);
        Enregistrer(th,15,8,8.0);
        Assert(La_Valeur(th,1,1) = 2.0);
        Put("OK 1 1");
        Assert(La_Valeur(th,1,4) = 2.5);
        Put("OK 1 4");
    end test_enregistrer;

begin
    test_enregistrer;
end test_th;