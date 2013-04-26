class ImperiumController < ApplicationController
  def sprava
    @title = 'Sprava Imperia'
    @courtship = User.dvorane
    @veziri = User.veziri
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @imperium = House.imperium
    @houses = House.playable
    
    @arrakis = Planet.arrakis
    @leno = Field.find_by_planet_id(@arrakis)
    if @spravce
      @melange = @leno.vynos('melange')
    else
      @melange = 0.0
    end
    @gilde = Prepocet.melanz_gilde(@melange)
    @operations = Operation.imperialni.seradit.limit(5)
    @hraci = User.order(:nick)
  end
  
  def show
    @title = 'Imperium'
    @courtship = User.dvorane
    @veziri = User.veziri
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @imperium = House.imperium
    @houses = House.playable
    
    @arrakis = Planet.arrakis
    @leno = Field.find_by_planet_id(@arrakis)
    if @spravce
      @melange = @leno.vynos('melange')
    else
      @melange = 0.0
    end
    @gilde = Prepocet.melanz_gilde(@melange)
    @operations = Operation.imperialni.seradit.limit(5)
  end
  
  def posli_imperialni_suroviny
    rod = House.imperium    
    msg = ''
    
    if params[:rodu_solary].to_i > 0.0 || params[:rodu_melanz].to_f > 0.0
      rodu = House.find(params[:rod_id_suroviny])
      msg << "Rodu #{rodu.name} poslano "
    end
    if params[:rodu_solary].to_i > 0.0 && params[:rodu_solary].to_i <= rod.solar
      rod.update_attribute(:solar, rod.solar - params[:rodu_solary].to_i)
      rodu.update_attribute(:solar, rodu.solar + params[:rodu_solary].to_i)
      msg << " #{params[:rodu_solary]} S "
    end
    if params[:rodu_melanz].to_f > 0.0 && params[:rodu_melanz].to_f <= rod.melange
      rod.update_attribute(:melange, rod.melange - params[:rodu_melanz].to_f)
      rodu.update_attribute(:melange, rodu.melange + params[:rodu_melanz].to_f)
      msg << " #{params[:rodu_melanz]} mg melanze "
    end 
    
    flash[:notice] = msg
    Imperium.zapis_operaci(msg + " hracem #{current_user.nick}.")
    rodu.zapis_operaci(msg.gsub("Rodu #{rodu.name} poslano ", "Obdrzeno z imperialni pokladny ") + " od hrace #{current_user.nick}.")
    redirect_to sprava_imperia_path
  end
end