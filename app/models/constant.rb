# encoding: utf-8
class Constant
  # veskere konstanty jsou zde
  
  #KSP = Global.vrat('k_solar_produkce', 4)
  def self.ksp
    Global.vrat('k_solar_produkce', 4)
  end
  #KMAP = Global.vrat('k_material_produkce', 4)
  def self.kmap
    Global.vrat('k_material_produkce', 4)
  end
  #KMEP = Global.vrat('k_melanz_produkce', 4)
  def self.kmep
    Global.vrat('k_melanz_produkce', 4)
  end
  #KEP = Global.vrat('k_exp_produkce', 4)
  def self.kep
    Global.vrat('k_exp_produkce', 4)
  end
  #KPP = Global.vrat('k_population_produkce', 4)
  def self.kpp
    Global.vrat('k_population_produkce', 4)
  end

  #KSV = Global.vrat('k_solar_vydej', 4)
  def self.ksv
    Global.vrat('k_solar_vydej', 4)
  end
  #KMAV = Global.vrat('k_material_vydej', 4)
  def self.kmav
    Global.vrat('k_material_vydej', 4)
  end
  #KMEV = Global.vrat('k_melanz_vydej', 4)
  def self.kmev
    Global.vrat('k_melanz_vydej', 4)
  end
  #KEV = Global.vrat('k_exp_vydej', 4)
  def self.kev
    Global.vrat('k_exp_vydej', 4)
  end
  #KPV = Global.vrat('k_population_vydej', 4)
  def self.kpv
    Global.vrat('k_population_vydej', 4)
  end

  #KVYNOSS = Global.vrat('k_solar_vynos', 4)
  def self.kvynoss
    Global.vrat('k_solar_vynos', 4)
  end
  #KVYNOSMA = Global.vrat('k_material_vynos', 4)
  def self.kvynosma
    Global.vrat('k_material_vynos', 4)
  end
  #KVYNOSME = Global.vrat('k_melanz_vynos', 4)
  def self.kvynosme
    Global.vrat('k_melanz_vynos', 4)
  end
  #KVYNOSE = Global.vrat('k_exp_vynos', 4)
  def self.kvynose
    Global.vrat('k_exp_vynos', 4)
  end
  #KVYNOSP = Global.vrat('k_population_vynos', 4)
  def self.kvynosp
    Global.vrat('k_population_vynos', 4)
  end

  # aplikace
  ADMIN_EMAIL = "admin@duneonline.cz"
  
  # vypocty
  #ZAKL_CENA_NOVE_PLANETY = Global.vrat('zakl_cena_planety', 4)
  def self.zakl_cena_planety
    Global.vrat('zakl_cena_planety', 4)
  end

  #ZAKL_CENA_NOVEHO_LENA = Global.vrat('zakl_cena_lena', 4)
  def self.zakl_cena_lena
    Global.vrat('zakl_cena_lena', 4)
  end

  # planeta
  #PLANETA_DOSTUPNA_PO = Global.vrat('planeta_dostupna_po', 4)
  def self.planeta_dostupna_po
    Global.vrat('planeta_dostupna_po', 4)
  end

  # leno
  #BUDOV_NA_LENO = Global.vrat('budov_na_leno', 4)
  def self.budov_na_leno
    Global.vrat('budov_na_leno', 4)
  end
  #VYNOS_BEZ_POP = 0.1
  def self.vynos_bez_pop
    0.1
  end

  # Gilda
  def self.gilda_melanz_pevna
    Global.vrat('gilda_melanz_pevna_castka', 4)
  end
  
  def self.gilda_melanz_procenta
    Global.vrat('gilda_melanz_procenta', 4)
  end

  # Volby
  def self.pristi_volby
    Global.vrat('pristi_volby', 2)
  end
  
  def self.volba_imperatora
    Global.vrat('volba_imperatora', 1)
  end
  
  def self.konec_volby_imperatora
    Global.vrat('konec_volby_imperatora', 2)
  end
end