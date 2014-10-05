require 'thinreports/generator/pdf/document/font'

ThinReports::Generator::PDF::Font.module_eval do

  FONT_STORE = File.join(ThinReports::ROOTDIR, 'resources', 'fonts')
  INTERNAL_FONT_STORE = Rails.root.join('vendor', 'fonts', 'times_new_roman')

  BUILTIN_FONTS = {
      'IPAMincho'  => {:normal => File.join(FONT_STORE, 'ipam.ttf')},
      'IPAPMincho' => {:normal => File.join(FONT_STORE, 'ipamp.ttf')},
      'IPAGothic'  => {:normal => File.join(FONT_STORE, 'ipag.ttf')},
      'IPAPGothic' => {:normal => File.join(FONT_STORE, 'ipagp.ttf')}
  }

  private

  def setup_fonts
    BUILTIN_FONTS['IPAMincho'] = { normal: File.join(INTERNAL_FONT_STORE, 'Times_New_Roman.ttf'),
                                   bold: File.join(INTERNAL_FONT_STORE, 'Times_New_Roman_Bold.ttf'),
                                   italic: File.join(INTERNAL_FONT_STORE, 'Times_New_Roman_Italic.ttf'),
                                   bold_italic: File.join(INTERNAL_FONT_STORE, 'Times_New_Roman_Bold_Italic.ttf')
    }


    # Install built-in fonts.
    pdf.font_families.update(BUILTIN_FONTS)

    # Install fall-back font that IPAMincho.
    fallback_font = BUILTIN_FONTS['IPAMincho'][:normal]
    pdf.font_families['FallbackFont'] = {:normal      => fallback_font,
                                         :bold        => fallback_font,
                                         :italic      => fallback_font,
                                         :bold_italic => fallback_font}
    # Setup fallback font.
    pdf.fallback_fonts(['FallbackFont'])

    # Create aliases from the font list provided by Prawn.
    pdf.font_families.update(
        'Courier New'     => pdf.font_families['Courier'],
        'Times New Roman' => pdf.font_families['Times-Roman']
    )
  end

  # @return [String]
  def default_family
    'Helvetica'
  end

  # @param [String] family
  # @return [String]
  def default_family_if_missing(family)
    pdf.font_families.key?(family) ? family : default_family
  end

  # @param [String] font
  # @param [Symbol] style
  # @return [Boolean]
  def font_has_style?(font, style)
    (f = pdf.font_families[font]) && f.key?(style)
  end
end

