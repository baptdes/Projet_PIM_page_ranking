with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions;        use SDA_Exceptions;

package body TH is

    procedure Couplage(Couple: out T_Couple; Cle1 : in T_Cle ; Cle2 : in T_Cle) is
    begin
        Couple.Cle_1 := Cle1;
        Couple.Cle_2 := Cle2;
    end Couplage;

    procedure Initialiser(TH: out T_TH) is
	begin
        for i in 1..Capacite loop
            LCA_TH.Initialiser(TH(i));
        end loop;
    end Initialiser;

    procedure Detruire (TH : in out T_TH) is
    begin
        for i in 1..Capacite loop
            LCA_TH.Detruire (TH(i));
        end loop;
	end Detruire;

    procedure Afficher_Debug (TH : in T_TH) is
       procedure afficher_debug_lca is new
                LCA_TH.Afficher_Debug(Afficher_Cle => afficher_cle, Afficher_Donnee => afficher_donnee);
    begin
        for i in 1..Capacite loop
            Put ("LCA numéro");
            Put (i);
            New_Line;
            afficher_debug_lca(TH(i));
            New_Line;
        end loop;
    end Afficher_Debug;


	function Est_Vide (TH : T_TH) return Boolean is
    begin
        for i in 1..Capacite loop
            if not LCA_TH.Est_Vide(TH(i)) then
                return false;
            else
                null;
            end if;
        end loop;
        return true;
	end Est_Vide;


    function Taille (TH : in T_TH) return Integer is
        taille: Integer;
    begin
        taille := 0;
        for i in 1..Capacite loop
            taille := taille + LCA_TH.Taille(TH(i));
        end loop;
        return taille;
	end Taille;

    procedure Enregistrer (TH : in out T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle; Valeur : in T_Valeur) is
        indice: Integer;
        Couple: T_Couple;
    begin
        indice := fonction_hachage(Capacite,Cle1,Cle1);
        Couplage(Couple, Cle1, Cle2);
        LCA_TH.Enregistrer(TH(indice), Couple, Valeur);
    end Enregistrer;


    function Cle_Presente (TH : in T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle) return Boolean is
        indice: Integer;
        Couple: T_Couple;
    begin
        indice := fonction_hachage(Capacite,Cle1,Cle2);
        Couplage(Couple, Cle1, Cle2);
        return (LCA_TH.Cle_Presente(TH(indice), Couple));
    end Cle_Presente;

    function La_Valeur (TH : in T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle) return T_Valeur is
        indice: Integer;
        Couple: T_Couple;
	begin
        indice := fonction_hachage(Capacite,Cle1,Cle2);
        Couplage(Couple, Cle1, Cle2);
        return (LCA_TH.La_Valeur(TH(indice), Couple));
	end La_Valeur;


    procedure Supprimer (TH : in out T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle) is
        indice: Integer;
        Couple: T_Couple;
	begin
        indice := fonction_hachage(Capacite,Cle1,Cle2);
        Couplage(Couple, Cle1, Cle2);
        LCA_TH.Supprimer(TH(indice), Couple);
    end Supprimer;

    procedure Pour_Chaque (TH : in T_TH) is
        procedure traiter_lca is new
                LCA_TH.Pour_Chaque(Traiter => Traitement);
    begin
        for i in 1..Capacite loop
            traiter_lca(TH(i));
        end loop;
	end Pour_Chaque;


end TH;
