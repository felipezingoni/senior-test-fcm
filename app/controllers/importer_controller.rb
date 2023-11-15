class ImporterController < ApplicationController
  def form
  end

  def upload
    require 'csv'
    begin
      # Opciones de parsear el CSV
      csv_options = { headers: true, col_sep: ',', quote_char: '"' }

      # Iterar sobre cada fila del CSV
      CSV.parse(params[:csv].read, csv_options) do |row|
        # Busca o determina la House attributes
        house_name = row['house'] || "Without houseName"
        house_description = row['house_description'] || "Without houseDescription "
        house_sigil_url = row['house_sigil_url'] || "Without houseURL_sigilo "

        # Busca o crea la House
        house = House.find_or_create_by(name: house_name) do |h|
          h.description = house_description
          h.sigil_url = house_sigil_url
        end

        # Atributos del Character
        character_attributes = {
          name: row['name'],
          house_id: house&.id,
          description: row['description'],
          biography: row['biography'],
          personality: row['personality'],
          seasons: row['seasons'],
          titles: row['titles'],
          status: row['status'],
          death: row['death'],
          origin: row['origin'],
          allegiance: row['allegiance'],
          culture:  row['culture'],
          religion: row['religion'],
          predecessor:  row['predecessor'],
          successor:  row['successor'],
          father:  row['father'],
          mother:  row['mother'],
          spouse:  row['spouse'],
          children:  row['children'],
          siblings:  row['siblings'],
          lovers:  row['lovers'],
          # image_1_src:  row['image_1_src'],
          # image_1_caption:  row['image_1_caption'],
          # image_2_src:  row['image_2_src'],
          # image_2_caption:  row['image_2_caption'],
          # image_3_src:  row['image_3_src'],
          # image_3_caption:  row['image_3_caption'],
          # image_4_src:  row['image_4_src'],
          # image_4_caption:  row['image_4_caption'],
          # image_5_src:  row['image_5_src'],
          # image_5_caption:  row['image_5_caption'],
          # image_6_src:  row['image_6_src'],
          # image_6_caption:  row['image_6_caption'],
          # image_7_src:  row['image_7_src'],
          # image_7_caption:  row['image_7_caption'],
          # image_8_src:  row['image_8_src'],
          # image_8_caption:  row['image_8_caption']
        }

        # Busca o crea el Character
        Character.find_or_create_by(name: row['name']) do |character|
          character.assign_attributes(character_attributes)
        end
      end
      flash[:notice] = 'Archivo procesado con éxito.'
    rescue => e
      flash[:alert] = "Error al procesar el archivo: #{e.message}"
    end
    redirect_to characters_path
  end

  private

  def csv_options
    {
      headers: true,
      header_converters: :symbol,
    }
  end
end
