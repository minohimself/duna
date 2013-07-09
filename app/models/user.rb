# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string(255)      not null
#  nick          :string(255)      not null
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  house_id      :integer          not null
#  subhouse_id   :integer
#  solar         :decimal(12, 4)   default(0.0)
#  melange       :decimal(12, 4)   default(0.0)
#  exp           :decimal(12, 4)   default(0.0)
#  leader        :boolean          default(FALSE)
#  mentat        :boolean          default(FALSE)
#  army_mentat   :boolean          default(FALSE)
#  diplomat      :boolean          default(FALSE)
#  general       :boolean          default(FALSE)
#  vicegeneral   :boolean          default(FALSE)
#  landsraad     :boolean          default(FALSE)
#  arrakis       :boolean          default(FALSE)
#  emperor       :boolean          default(FALSE)
#  regent        :boolean          default(FALSE)
#  court         :boolean          default(FALSE)
#  vezir         :boolean          default(FALSE)
#  admin         :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  influence     :decimal(, )
#  web           :string(255)      default(" ")
#  icq           :string(255)      default(" ")
#  gtalk         :string(255)      default(" ")
#  skype         :string(255)      default(" ")
#  facebook      :string(255)      default(" ")
#  presentation  :text             default(" ")
#  active        :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :house_id, :subhouse_id, :solar, :melange
  attr_accessible :exp, :leader, :mentat, :army_mentat, :diplomat, :general, :vicegeneral, :landsraad, :arrakis
  attr_accessible :emperor, :regent, :court, :vezir, :admin, :nick, :influence
  attr_accessible :web, :icq, :gtalk, :skype, :facebook, :presentation, :active

  attr_accessor :password
  before_save :prepare_password

  # after_save :napln_suroviny

  belongs_to :house
  has_many :fields
  has_many :votes, :foreign_key => 'elective'

  has_many :operations

  has_many :researches
  has_many :technologies, :through => :researches
  
  has_many :eods

  has_many :polls
  has_many :laws, :through => :polls

  validates :username, :presence => true, :uniqueness => true
  validates :password, :presence => true, :on => :create
  validates_confirmation_of :password
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  validates_length_of :password, :minimum => 4, :allow_blank => true
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = User.find_by_username(login) || User.find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def change_password(pass)
    update_attribute "password_hash", encrypt_password(pass)
    true
  end

  def najdi_planety
    planets = []
    for field in self.fields do
      planets << field.planet unless planets.include?(field.planet)
    end
    planets
  end

  def najdi_hodnosti
    hodnosti = []
    hodnosti << "Emperor" if self.emperor
    hodnosti << "Regent" if self.regent
    hodnosti << "Clen dvora" if self.court
    hodnosti << "Vezir" if self.vezir
    hodnosti << "Leader" if self.leader
    hodnosti << "Mentat" if self.mentat
    hodnosti << "Vojensky Mentat" if self.army_mentat
    hodnosti << "Diplomat" if self.diplomat
    hodnosti << "General" if self.general
    hodnosti << "ViceGeneral" if self.vicegeneral
    hodnosti << "Poslanec" if self.landsraad
    hodnosti << "Spravce Arrakis" if self.arrakis
    hodnosti << "ADMIN" if self.admin
    hodnosti
  end

  def hlasuj(koho, typ)
    if vote = Vote.where(:house_id => self.house.id, :elector => self.id, :typ => typ).first
      self.zapis_operaci("Ve volbe na pozici #{typ} jsi zmenil hlas z #{User.find(vote.elective).nick} na #{User.find(koho).nick}.")
      vote.update_attribute(:elective, koho.id)
    else
      self.zapis_operaci("Ve volbe na pozici #{typ} jsi hlasoval pro #{User.find(koho).nick}.")
      Vote.new(:house_id => self.house.id, :elector => self.id, :elective => koho.id, :typ => typ).save
    end
  end

  def koho_jsem_volil(typ)
    voleno = self.house.votes.where(:typ => typ, :elector => self.id).first
    if voleno
      User.find(voleno.elective).nick
    else
      'nikdo'
    end
  end

  def vol_imperatora(koho)
    imp = House.imperium
    typ = 'imperator'
    if vote = Vote.where(:house_id => imp.id, :elector => self.id, :typ => typ).first
      #self.zapis_operaci("Ve volbe na pozici Imperatora jsi zmenil hlas z #{User.find(vote.elective).nick} na #{User.find(koho).nick}.")
      vote.update_attribute(:elective, koho.id)
    else
      #self.zapis_operaci("Ve volbe na pozici Imperatora jsi hlasoval pro #{User.find(koho).nick}.")
      Vote.new(:house_id => imp.id, :elector => self.id, :elective => koho.id, :typ => typ).save
    end
  end

  def koho_jsem_volil_imperatorem
    voleno = House.imperium.votes.where(:typ => 'imperator', :elector => self.id).first
    if voleno
      User.find(voleno.elective).nick
    else
      'nikdo'
    end
  end

  def napln_suroviny
    # asi rozdelime pak podle rodu
    self.update_attributes(:solar => 1600.0, :melange => 2.0, :exp => 0)
    self.fields.first.resource.update_attributes(:population => 10000, :material => 1700.0)
  end

  def celkovy_material
    mat = 0.0
    for field in self.fields.includes(:resource) do
      mat += field.resource.material
    end
    mat
  end

  def celkova_populace
    pop = 0
    for field in self.fields.includes(:resource) do
      pop += field.resource.population
    end
    pop
  end

  def osidlene_planety
    plt_id = []
    for field in self.fields do
      plt_id << field.planet unless plt_id.include?(field.planet)
    end
    plt_id.sort!
  end

  def to_i
    self.id
  end

  def dovolene_budovy(kind)
    # TODO dovolene budovy podle tech levelu
    Building.where(:kind => kind, :level => [1]).all
  end

  def stat_se(cim)  # cim = presne nazev attributu
    #self.zapis_operaci("Od ted jsem #{cim}.")
    self.update_attribute(cim, true)
  end

  def prestat_byt(cim)  # cim = presne nazev attributu
    #self.zapis_operaci("Uz dale nejsem #{cim}.")
    self.update_attribute(cim, false)
  end


  def zobraz_vyskum
    self.technologies.includes(:researches).order(:name) 
  end

  def melange_bonus
    # TODO bonus z vyzkumu
    1.0
  end

  def self.spravce_arrakis
    User.find_by_arrakis(true)
  end

  def self.imperator
    User.find_by_emperor(true)
  end
  
  def self.regenti
    User.find_all_by_regent(true)
  end

  def jmenuj_spravcem
    self.stat_se('arrakis')
    Global.prepni('bezvladi_arrakis', 2, nil)
  end

  def odeber_spravcovstvi
    self.prestat_byt('arrakis')
    Global.prepni('bezvladi_arrakis', 2, 3.days.since)
  end

  def zapis_operaci(content, kind = "U")
    self.operations << Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now)
  end

  def vliv
    vl = self.politicke_postaveni * (self.fields.count + (self.celkova_populace / 100000.0))
    return vl.round(4)
  end

  def domovske_leno
    self.fields.where(:planet_id => Planet.domovska_rodu(self.house)).first
  end
  def vyskumane_tech(id)
        vyskumane_tech =  self.researches.where('technology_id' => id).first
        if vyskumane_tech
          return vyskumane_tech.lvl
        else
          return 1
        end
  end


  def politicke_postaveni
    # Imperátor > Mistodržící > Regent > Vůdce > Poslanec > Mentat > Vojenský mentat > Diplomat > Guvernér
    pp = 1
    if self.emperor?
      pp += 0.05
    else
      if self.arrakis?
        pp += 0.05
      else
        if self.regent?
          pp += 0.02
        else
          if self.leader?
            pp += 0.02
          else
            if self.landsraad?
              pp += 0.02
            else
              if self.court? || self.vezir?
                pp += 0.02
              else
                if self.mentat? || self.army_mentat? || self.diplomat?
                  pp += 0.01
                else
                  if self.general? || self.vicegeneral?
                    pp += 0.01
                  else

                  end
                end
              end
            end
          end
        end
      end
    end

    return pp
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  scope :dvorane, where(:court => true)
  scope :veziri, where(:vezir => true)
  scope :poslanci, where(:landsraad => true)
  scope :players, where(:admin => false)
  scope :by_nick, order(:nick)
end
