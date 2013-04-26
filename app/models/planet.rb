# encoding: utf-8
# == Schema Information
#
# Table name: planets
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  planet_type_id   :integer          not null
#  house_id         :integer
#  system_name      :string(255)
#  position         :integer
#  available_to_all :boolean          default(FALSE)
#  discovered_at    :date             default(Thu, 13 Dec 2012)
#  created_at       :datetime
#  updated_at       :datetime
#

class Planet < ActiveRecord::Base
  attr_accessible :name, :planet_type_id, :house_id, :available_to_all, :discovered_at, :system_name, :position

  belongs_to :house
  belongs_to :planet_type
  belongs_to :system, :primary_key => 'system_name', :foreign_key => 'system_name'
  has_many :fields
  
  def vytvor_pole(user)
    Field.new(
      :planet_id => self.id,
      :name => self.name + " - " + user.nick + " - " + (self.vlastni_pole(user).count + 1).to_s,
      :user_id => user.id,
      :pos_x => user.house.id,
      :pos_y => user.id
    )
  end
  
  def oznaceni
    self.system.id.to_s + "." + self.position.to_s
  end
  
  def arrakis?
    self.name == "Arrakis"
  end

  def obsazenost
    max = self.max_poli
    aktualne = self.aktualne_obsazeno
    aktualne.to_s + "/" + max.to_s
  end

  def max_poli
    if self.planet_type.name == "Domovská"
      max_poli = "-"
    else
      max_poli = self.planet_type.fields
    end
    max_poli
  end

  def aktualne_obsazeno
    self.fields.count
  end

  def background
    if self.name == "Arrakis"
      "planety/arrakis.png"
    else
      case self.planet_type.name
      when "Měsíc"
        "planety/1.png"
      when "Typ Vesuvia"
        "planety/2.png"
      when "Pengaranský typ"
        "planety/3.png"
      when "Teranský typ"
        "planety/4.png"
      when "Dyrovský typ"
        "planety/5.png"
      when "Marganský typ"
        "planety/6.png"
      when "Domovská"
        rod = self.house.name
        if rod == "Titáni"
          "planety/dpl-Titani.png"
        elsif rod == "Renegáti"
          "planety/dpl-renegati.png"
        else
          "planety/dpl-" + rod + ".png"
        end
      else
      "planety/neznama.png"
      end
    end
  end
  
  def vlastni_pole(user)
    self.fields.where(:user_id => user.id)
  end
  
  def zastoupeni_rodu
    self.fields.joins(:user, :house).includes(:house).count(:id, :group => 'houses.name')
    #self.fields.joins(:user, :house).count(:id, :group => :house)
  end
  
  def cena_noveho_lena_mel
    Vypocty.cena_noveho_lena_melanz(self)
  end
  def cena_noveho_lena_sol
    Vypocty.cena_noveho_lena_solary(self)
  end
  
  def vynos(user, ceho)
    vynos = 0.0
    for field in self.fields.vlastnik(user).includes(:buildings) do
      vynos += field.vynos(ceho)
    end
    vynos
  end
  
  def osidlitelna?(user)
    (self.house == user.house || self.available_to_all) && self.max_poli > self.fields.count
  end
  
  def domovska?
    self.planet_type_id == PlanetType.find_by_name("Domovská").id
  end
  
  def self.arrakis
    @duna ||= Planet.find_by_name("Arrakis")
  end
  
  def self.kaitan
    @kaitan ||= Planet.find_by_name("Kaitan")
  end
  
  def melange_bonus
    if vlastnik = User.spravce_arrakis
      vlastnik.melange_bonus
    else
      0.0
    end
  end
  
  def agresivita_fremenu
    # TODO jak pocitat???
    10.0
  end
  
  def zastoupene_rody
    a = []
    for field in self.fields.includes(:user, :house) do
      if self == Planet.arrakis || self == Planet.kaitan
        rod = House.imperium.name
      else
        rod = field.user.house.name
      end
      if a.assoc(rod) == nil
        a << [rod, 1]
      else
        a.assoc(rod)[1] += 1
      end
    end
    a.sort! { |a,b| a[1] <=> b[1] }
    return a
  end
  
  def dominantni_rod
    a = self.zastoupene_rody
    if a[0]
      a[0]
    else
      ''
    end
  end
  
  def celkova_populace(user)
    pop = 0.0
    for field in self.fields.vlastnik(user).includes(:resource) do
      pop += field.resource.population
    end
    pop
  end
  def celkovy_material(user)
    mat = 0.0
    for field in self.fields.vlastnik(user).includes(:resource) do
      mat += field.resource.material
    end
    mat
  end
  
  scope :domovska, lambda { |user| where(:house_id => user.house.id, :planet_type_id => PlanetType.find_by_name("Domovská"))}
  scope :domovska_rodu, lambda { |house| where(:house_id => house.id, :planet_type_id => PlanetType.find_by_name("Domovská"))}
  scope :domovske, where(:planet_type_id => PlanetType.find_by_name("Domovská"))
  scope :osidlitelna, where(:available_to_all => true)
  scope :objevene, where("available_to_all = ? AND planet_type_id <> ? AND name <> ?", false, PlanetType.find_by_name("Domovská").try(:id), 'Arrakis')
  #scope :objevena, where(:available_to_all => false, :planet_type_id => PlanetType.find_by_name("Domovská"))
  scope :viditelna, lambda { |house| where(:house_id => house.id, :available_to_all => false)}

end
