// 색상 및 트림 매핑 정보
// 사용자가 별도로 업로드할 필요 없이 앱에 내장된 데이터

class ColorInfo {
  final String name;
  final String hexCode;
  const ColorInfo({required this.name, required this.hexCode});
}

class TrimInfo {
  final String name;
  final String hexCode;
  const TrimInfo({required this.name, required this.hexCode});
}

class ColorMapping {
  // 외장 색상 매핑 (COLOR → COLOR_NAME + HEX)
  static const Map<String, ColorInfo> colors = {
    // Black & Dark colors
    '033': ColorInfo(name: 'designo mocha black metallic', hexCode: '#1C1410'),
    '040': ColorInfo(name: 'paintwork black', hexCode: '#0A0A0A'),
    '041': ColorInfo(name: 'graphite metallic', hexCode: '#2F2F2F'),
    '054': ColorInfo(name: 'obsidian black magno', hexCode: '#0B0B0B'),
    '149': ColorInfo(name: 'designo cashmere white magno', hexCode: '#E8E3DC'),
    '124': ColorInfo(name: 'cloud grey non-metallic', hexCode: '#C0C0C0'),
    '190': ColorInfo(name: 'greenheller dark olive magno', hexCode: '#3C3D28'),
    '794': ColorInfo(name: 'mojave white', hexCode: '#F5F0E8'),
    '183': ColorInfo(name: 'magnetite black', hexCode: '#1A1A1A'),
    '191': ColorInfo(name: 'cosmos black', hexCode: '#0D0D0D'),
    '197': ColorInfo(name: 'obsidian Black Metallic', hexCode: '#0B0B0B'),
    '255': ColorInfo(name: 'G manufaktur olive metallic', hexCode: '#4A4D3F'),
    '211': ColorInfo(name: 'magma stone (brown)', hexCode: '#3E2E28'),
    '296': ColorInfo(name: 'graphite silver metallic', hexCode: '#4A4A4A'),
    '297': ColorInfo(name: 'iridium silver', hexCode: '#6B6B6B'),
    '368': ColorInfo(name: 'onyx black metallic', hexCode: '#0A0A0A'),
    '421': ColorInfo(name: 'lunar green pearl magno', hexCode: '#2C3B2F'),
    '185': ColorInfo(name: 'cavansite light blue metallic', hexCode: '#4A7C9E'),
    '458': ColorInfo(name: 'jupiter red', hexCode: '#8B0000'),
    '589': ColorInfo(name: 'spectral blue magno', hexCode: '#1E3A5F'),
    '335': ColorInfo(name: 'Nautic blue metallic', hexCode: '#1C3D5C'),
    '623': ColorInfo(name: 'cirrus silver metallic', hexCode: '#C0C5C8'),
    '644': ColorInfo(name: 'designo brilliant blue magno', hexCode: '#1A3B5F'),
    '650': ColorInfo(name: 'tanzanite blue metallic', hexCode: '#2B4B7C'),
    '658': ColorInfo(name: 'copper orange magno', hexCode: '#B8542E'),
    '659': ColorInfo(name: 'sunset white magno', hexCode: '#F5E6D3'),
    '660': ColorInfo(name: 'rubellite red metallic', hexCode: '#8B1538'),
    '662': ColorInfo(name: 'designo mountain grey magno', hexCode: '#5A5A5A'),
    '663': ColorInfo(name: 'alpine grey uni', hexCode: '#7A7A7A'),
    '677': ColorInfo(name: 'Kalahari gold magno', hexCode: '#B8904D'),
    '691': ColorInfo(name: 'yellowstone solid', hexCode: '#D4AF37'),
    '696': ColorInfo(name: 'night black', hexCode: '#0A0A0A'),
    '771': ColorInfo(name: 'inidlt light grey metallic', hexCode: '#B0B0B0'),
    '775': ColorInfo(name: 'obsidian black', hexCode: '#0B0B0B'),
    '787': ColorInfo(name: 'polar white', hexCode: '#F8F8F8'),
    '789': ColorInfo(name: 'high-tech silver magno', hexCode: '#A0A0A0'),
    '796': ColorInfo(name: 'alpine brown metallic', hexCode: '#4A3428'),
    '798': ColorInfo(name: 'designo diamond white bright', hexCode: '#FAFAFA'),
    '799': ColorInfo(name: 'arctic white', hexCode: '#F5F5F5'),
    '802': ColorInfo(name: 'designo Kalahari gold metallic', hexCode: '#B8904D'),
    '819': ColorInfo(name: 'galaxy blue metallic', hexCode: '#1C3D5F'),
    '817': ColorInfo(name: 'desert gold metallic', hexCode: '#C9A86A'),
    '823': ColorInfo(name: 'lapis blue solid', hexCode: '#1E3A8A'),
    '825': ColorInfo(name: 'classic green non-metallic', hexCode: '#2D5016'),
    '831': ColorInfo(name: 'victory grey solid', hexCode: '#696969'),
    '842': ColorInfo(name: 'budellght blue metallic', hexCode: '#87CEEB'),
    '858': ColorInfo(name: 'hailong blue', hexCode: '#0F4C81'),
    '835': ColorInfo(name: 'designo quartz white', hexCode: '#EFEFEF'),
    '888': ColorInfo(name: 'hyper blue metallic', hexCode: '#0066CC'),
    '890': ColorInfo(name: 'lavender blue metallic', hexCode: '#9966CC'),
    '895': ColorInfo(name: 'spectral blue', hexCode: '#1E3A5F'),
    '896': ColorInfo(name: 'AMG bright red', hexCode: '#DC143C'),
    '807': ColorInfo(name: 'ruby black', hexCode: '#350010'),
    '826': ColorInfo(name: 'blauld Blue metallic', hexCode: '#1C3D5F'),
    '914': ColorInfo(name: 'sun yellow', hexCode: '#FFD700'),
    '907': ColorInfo(name: 'black dark silver metallic', hexCode: '#2F2F2F'),
    '929': ColorInfo(name: 'vintage blue solid', hexCode: '#4A5D7C'),
    '947': ColorInfo(name: 'scandium silver metallic', hexCode: '#B8C0C8'),
    '963': ColorInfo(name: 'alpine grey uni', hexCode: '#7A7A7A'),
    '983': ColorInfo(name: 'G manufaktur rubicon grey', hexCode: '#5A5A5A'),
    '988': ColorInfo(name: 'shadow grey metallic', hexCode: '#4A4A4A'),
    '962': ColorInfo(name: 'designo iridium silver magno', hexCode: '#6B6B6B'),
    '989': ColorInfo(name: 'emerald green', hexCode: '#046307'),
    '991': ColorInfo(name: 'designo polar silver magno', hexCode: '#D0D0D0'),
    '992': ColorInfo(name: 'selenite grey metallic', hexCode: '#808080'),
    '993': ColorInfo(name: 'obsidian black', hexCode: '#0B0B0B'),
    '996': ColorInfo(name: 'designo hyacinth red metallic', hexCode: '#8B1538'),
    '999': ColorInfo(name: 'designo cardinal red metallic', hexCode: '#C41E3A'),
    '908': ColorInfo(name: 'antifreeze blue', hexCode: '#00BFFF'),
    
    // Additional colors from image
    '649': ColorInfo(name: 'brilliant blue', hexCode: '#0066FF'),
    '721': ColorInfo(name: 'denimblue', hexCode: '#1560BD'),
    '701': ColorInfo(name: 'Patagonia red solid', hexCode: '#B22222'),
    '149A': ColorInfo(name: 'designo cashmere white magno', hexCode: '#E8E3DC'),
  };

  // 트림 색상 매핑 (TRIM → TRIM_NAME + HEX)
  static const Map<String, TrimInfo> trims = {
    '101': TrimInfo(name: 'ARTICO black', hexCode: '#0A0A0A'),
    '105': TrimInfo(name: 'ARTICO beige/ espresso', hexCode: '#D4C5B0'),
    '111': TrimInfo(name: 'ARTICO beige', hexCode: '#D4C5B0'),
    '118': TrimInfo(name: 'ARTICO neva grey/ black', hexCode: '#4A4A4A'),
    '115': TrimInfo(name: 'ARTICO black', hexCode: '#0A0A0A'),
    '124': TrimInfo(name: 'ARTICO browny black', hexCode: '#3C2415'),
    '169': TrimInfo(name: 'ARTICO neva-nappa leather two-tone neva grey', hexCode: '#6B6B6B'),
    '104': TrimInfo(name: 'ARTICO sienna brown/ black', hexCode: '#8B4513'),
    '201': TrimInfo(name: 'leather black', hexCode: '#0A0A0A'),
    '204': TrimInfo(name: 'leather saddle tannin/ black sun-reflecting', hexCode: '#8B6914'),
    '205': TrimInfo(name: 'leather mercuedes-beige/ espresso brown sun-reflecting', hexCode: '#D4A574'),
    '207': TrimInfo(name: 'leather cranberry red/ black', hexCode: '#8B1538'),
    '208': TrimInfo(name: 'leather navy grey/ magma grey', hexCode: '#464646'),
    '211': TrimInfo(name: 'leather black sun-reflecting', hexCode: '#0A0A0A'),
    '214': TrimInfo(name: 'leather brown/black', hexCode: '#3C2415'),
    '215': TrimInfo(name: 'leather mercedes-black', hexCode: '#0A0A0A'),
    '218': TrimInfo(name: 'leather neva grey/ black sun-reflecting', hexCode: '#4A4A4A'),
    '221': TrimInfo(name: 'leather nappa grey black', hexCode: '#4A4A4A'),
    '224': TrimInfo(name: 'leather browny black', hexCode: '#3C2415'),
    '225': TrimInfo(name: 'leather silk beige/ espresso brown', hexCode: '#D4C5B0'),
    '227': TrimInfo(name: 'leather cranberry red/ black', hexCode: '#8B1538'),
    '228': TrimInfo(name: 'leather navy grey', hexCode: '#464646'),
    '229': TrimInfo(name: 'leather silk beige/ espresso brown', hexCode: '#D4C5B0'),
    '231': TrimInfo(name: 'leather black/ space grey', hexCode: '#2F2F2F'),
    '232': TrimInfo(name: 'leather silk beige', hexCode: '#E8D4B8'),
    '233': TrimInfo(name: 'leather black/ neva grey pearl/ silver', hexCode: '#3A3A3A'),
    '238': TrimInfo(name: 'leather two-tone classic red/ black', hexCode: '#8B0000'),
    '248': TrimInfo(name: 'leather two-tone titanium grey pearl/ black', hexCode: '#5A5A5A'),
    '258': TrimInfo(name: 'leather two-tone black/ cranberry red sun-reflecting', hexCode: '#6B0F1A'),
    '311': TrimInfo(name: 'ARTICO ferrino fabric two-tone black/ neva grey', hexCode: '#2F2F2F'),
    '372': TrimInfo(name: 'ARTICO ferrino fabric two-tone black indigo blue/ black', hexCode: '#1C1C3C'),
    '381': TrimInfo(name: 'ARTICO leather/ nappa', hexCode: '#3A3A3A'),
    '501': TrimInfo(name: 'Exclusive nappa leather black', hexCode: '#0A0A0A'),
    '504': TrimInfo(name: 'Exclusive nappa leather sienna brown/ black', hexCode: '#8B4513'),
    '505': TrimInfo(name: 'Exclusive nappa leather silk beige/ espresso brown', hexCode: '#D4C5B0'),
    '507': TrimInfo(name: 'Exclusive nappa Leather carmine red / black', hexCode: '#8B1538'),
    '508': TrimInfo(name: 'Exclusive leather nappa', hexCode: '#3A3A3A'),
    '511': TrimInfo(name: 'Exclusive nappa leather black/ platinum silver', hexCode: '#C0C0C0'),
    '514': TrimInfo(name: 'Exclusive nxt brown/ black', hexCode: '#3C2415'),
    '531': TrimInfo(name: 'Exclusive porcelain black', hexCode: '#1A1A1A'),
    '641': TrimInfo(name: 'DINAMICA non-suede leather/ DINAMICA microfibre in black mat', hexCode: '#0A0A0A'),
    '651': TrimInfo(name: 'DINAMICA/ ARTICO black', hexCode: '#0A0A0A'),
    '801': TrimInfo(name: 'leather black', hexCode: '#0A0A0A'),
    '804': TrimInfo(name: 'leather red brown', hexCode: '#8B4513'),
    '805': TrimInfo(name: 'Nappa leather macchiato beige/ espresso brown sun-reflecting', hexCode: '#C4A57B'),
    '811': TrimInfo(name: 'leather black', hexCode: '#0A0A0A'),
    '814': TrimInfo(name: 'Nappa leather red brown/ black', hexCode: '#6B2C1A'),
    '815': TrimInfo(name: 'Nappa leather macchiato honey/ whtb blue sun-reflecting', hexCode: '#D4A574'),
    '821': TrimInfo(name: 'Nappa leather black with red stitching', hexCode: '#0A0A0A'),
    '824': TrimInfo(name: 'AMG nappa leather, saddle brown', hexCode: '#8B6914'),
    '851': TrimInfo(name: 'Nappa leather black/ grey', hexCode: '#2F2F2F'),
    '854': TrimInfo(name: 'AMG nappa leather red brown/ black', hexCode: '#6B2C1A'),
    '855': TrimInfo(name: 'Nappa leather beige', hexCode: '#D4C5B0'),
    '892': TrimInfo(name: 'Nappa leather deep white black sun-reflecting', hexCode: '#F0F0F0'),
    '895': TrimInfo(name: 'Nappa leather deep white magma grey', hexCode: '#E8E8E8'),
    '896': TrimInfo(name: 'AMG nappa leather, titanium grey pearl/ black', hexCode: '#5A5A5A'),
    '857': TrimInfo(name: 'Nappa leather red/ pepper/ black', hexCode: '#8B0000'),
    '861': TrimInfo(name: 'Nappa leather black/ black', hexCode: '#0A0A0A'),
    '862': TrimInfo(name: 'Nappa leather red brown', hexCode: '#8B4513'),
    '865': TrimInfo(name: 'Nappa leather macchiato beige', hexCode: '#C4A57B'),
  };

  // 색상 코드로 색상명 조회
  static String? getColorName(String code) {
    return colors[code]?.name;
  }

  // 색상 코드로 HEX 코드 조회
  static String? getColorHex(String code) {
    return colors[code]?.hexCode ?? '#808080';
  }

  // 트림 코드로 트림명 조회
  static String? getTrimName(String code) {
    return trims[code]?.name;
  }

  // 트림 코드로 HEX 코드 조회
  static String? getTrimHex(String code) {
    return trims[code]?.hexCode ?? '#808080';
  }

  // 모든 색상 코드 목록 (필터링용)
  static List<String> getAllColorCodes() {
    return colors.keys.toList()..sort();
  }

  // 모든 트림 코드 목록 (필터링용)
  static List<String> getAllTrimCodes() {
    return trims.keys.toList()..sort();
  }
}
