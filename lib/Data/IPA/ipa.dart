class IPA {
  final String symbol;
  final String description;
  final String mouthPosition;
  final String tonguePosition;
  final List<String> examples;

  IPA({
    required this.symbol,
    required this.description,
    required this.mouthPosition,
    required this.tonguePosition,
    required this.examples,
  });
}

final ipaSounds = [
  IPA(
    symbol: '/ɪ/',
    description:
        'Đây là âm i ngắn, phát âm giống âm “i” của tiếng Việt nhưng ngắn hơn, bật nhanh.',
    mouthPosition: 'Môi hơi mở sang hai bên.',
    tonguePosition: 'Lưỡi hạ thấp.',
    examples: ['sit', 'hit', 'bit', 'kit'],
  ),
  IPA(
    symbol: '/i:/',
    description:
        'Là âm i dài, bạn đọc kéo dài âm “i”, âm phát từ trong khoang miệng chứ không thổi hơi ra.',
    mouthPosition: 'Môi mở rộng hai bên như đang mỉm cười.',
    tonguePosition: 'Lưỡi nâng cao lên.',
    examples: ['see', 'bean', 'keep', 'seat'],
  ),
  IPA(
    symbol: '/e/',
    description: 'Tương tự âm e tiếng Việt nhưng cách phát âm cũng ngắn hơn.',
    mouthPosition: 'Môi mở rộng sang hai bên rộng hơn so với âm /ɪ/.',
    tonguePosition: 'Lưỡi hạ thấp hơn âm /ɪ/.',
    examples: ['bed', 'red', 'set', 'men'],
  ),
  IPA(
    symbol: '/ə/',
    description: 'Âm ơ ngắn, phát như âm ơ tiếng Việt nhưng ngắn và nhẹ hơn.',
    mouthPosition: 'Môi hơi mở rộng.',
    tonguePosition: 'Lưỡi thả lỏng.',
    examples: ['sofa', 'again', 'supply', 'banana'],
  ),
  IPA(
    symbol: '/ɜ:/',
    description:
        'Âm này đọc là âm ơ nhưng cong lưỡi. Bạn phát âm / ə / rồi cong lưỡi lên, phát âm từ trong khoang miệng.',
    mouthPosition: 'Môi hơi mở rộng.',
    tonguePosition: 'Lưỡi cong lên, lưỡi chạm vào vòm miệng khi kết thúc âm.',
    examples: ['burn', 'birthday'],
  ),
  IPA(
    symbol: '/ʊ/',
    description:
        'Âm u ngắn, khá giống âm ư của tiếng Việt.Khi phát âm, không dùng môi mà đẩy hơi rất ngắn từ cổ họng.',
    mouthPosition: 'Môi hơi tròn.',
    tonguePosition: 'Lưỡi hạ thấp.',
    examples: ['good', 'put'],
  ),
  IPA(
    symbol: '/u:/',
    description:
        'Âm u dài, âm phát ra từ khoang miệng nhưng không thổi hơi ra, kéo dài âm u ngắn.',
    mouthPosition: 'Môi tròn.',
    tonguePosition: 'lưỡi nâng cao lên.',
    examples: ['goose', 'school'],
  ),
  IPA(
    symbol: '/ɒ/',
    description: 'Âm o ngắn, tương tự âm o tiếng Việt nhưng phát âm ngắn hơn.',
    mouthPosition: 'Môi hơi tròn.',
    tonguePosition: 'Lưỡi hạ thấp.',
    examples: ['hot', 'box'],
  ),
  IPA(
    symbol: '/ɔ:/',
    description:
        'Phát âm như âm o tiếng Việt nhưng rồi cong lưỡi lên, không phát âm từ khoang miệng.',
    mouthPosition: 'Tròn môi.',
    tonguePosition: 'Lưỡi cong lên chạm vào vòm miệng khi kết thúc âm.',
    examples: ['ball', 'law'],
  ),
  IPA(
    symbol: '/ʌ/',
    description:
        'Âm lai giữa âm ă và âm ơ của tiếng Việt, na ná âm ă hơn. Phát âm phải bật hơi ra.',
    mouthPosition: 'Miệng thu hẹp lại.',
    tonguePosition: 'Lưỡi hơi nâng lên cao.',
    examples: ['come', 'love'],
  ),
  IPA(
    symbol: '/ɑ:/',
    description: 'Âm a đọc kéo dài, âm phát ra từ khoang miệng.',
    mouthPosition: 'Môi mở rộng.',
    tonguePosition: 'Lưỡi hạ thấp.',
    examples: ['start', 'father'],
  ),
  IPA(
    symbol: '/æ/',
    description: 'Âm a bẹt, hơi giống âm a và e, âm có cảm giác bị nén xuống.',
    mouthPosition: 'Miệng mở rộng, môi dưới hạ thấp xuống.',
    tonguePosition: 'Lưỡi hạ rất thấp.',
    examples: ['trap', 'bad'],
  ),
  IPA(
    symbol: '/ɪə/',
    description:
        'Nguyên âm đôi.Phát âm chuyển từ âm / ʊ / rồi dần sang âm /ə/.',
    mouthPosition: 'Môi mở rộng dần nhưng không rộng quá.',
    tonguePosition: 'Lưỡi đẩy dần ra về phía trước.',
    examples: ['near', 'here'],
  ),
  IPA(
    symbol: '/eə/',
    description:
        'Phát âm bằng cách đọc âm  / e / rồi chuyển dần sang âm / ə /.',
    mouthPosition: 'Môi hơi thu hẹp.',
    tonguePosition: 'Lưỡi thụt dần về phía sau.',
    examples: [],
  ),
  IPA(
    symbol: '/ei/',
    description: 'Phát âm bằng cách đọc âm / e / rồi chuyển dần sang âm / ɪ /.',
    mouthPosition: 'Môi dẹt dần sang hai bên.',
    tonguePosition: 'Lưỡi hướng dần lên trên.',
    examples: ['face', 'day'],
  ),
  IPA(
    symbol: '/ɔɪ/',
    description: 'Phát âm bằng cách đọc âm / ɔ: / rồi chuyển dần sang âm /ɪ/.',
    mouthPosition: 'Môi dẹt dần sang hai bên.',
    tonguePosition: 'Lưỡi nâng lên và đẩy dần về phía trước.',
    examples: ['choice', 'boy'],
  ),
  IPA(
    symbol: '/aɪ/',
    description: 'Phát âm bằng cách đọc âm / ɑ: / rồi chuyển dần sang âm /ɪ/.',
    mouthPosition: 'Môi dẹt dần sang hai bên.',
    tonguePosition: 'Lưỡi nâng lên và hơi đẩy dần về trước.',
    examples: ['nice', 'try'],
  ),
  IPA(
    symbol: '/əʊ/',
    description: 'Phát âm bằng cách đọc âm / ə/ rồi chuyển dần sang âm / ʊ /.',
    mouthPosition: 'Môi từ hơi mở đến hơi tròn.',
    tonguePosition: 'Lưỡi lùi dần về phía sau.',
    examples: ['goat', 'show'],
  ),
  IPA(
    symbol: '/aʊ/',
    description: 'Phát âm bằng cách đọc âm / ɑ: / rồi chuyển dần sang âm /ʊ/.',
    mouthPosition: 'Môi Tròn dần.',
    tonguePosition: 'Lưỡi hơi thụt về phía sau.',
    examples: ['mouth', 'cow'],
  ),
  IPA(
    symbol: '/ʊə/',
    description: 'Đọc như uo, chuyển từ âm sau /ʊ/ sang âm giữa /ə/.',
    mouthPosition:
        'Khi bắt đầu, môi mở khá tròn, hơi bè, hướng ra ngoài, mặt lưỡi đưa vào phía trong khoang miệng và hướng lên gần ngạc trên.',
    tonguePosition:
        'Ngay sau đó, miệng hơi mở ra, đưa lưỡi lùi về giữa khoang miệng.',
    examples: ['sure', 'tour'],
  ),
  IPA(
    symbol: '/p/',
    description: 'Đọc gần giống âm P của tiếng Việt.',
    mouthPosition: 'Hai môi chặn luồng không khí trong miệng sau đó bật ra.',
    tonguePosition: ' Cảm giác dây thanh quản rung nhẹ.',
    examples: ['pen', 'copy'],
  ),
  IPA(
    symbol: '/b/',
    description: 'Đọc tương tự âm B trong tiếng Việt.',
    mouthPosition: 'Để hai môi chặng không khí từ trong miệng sau đó bật ra.',
    tonguePosition: ' Thanh quản rung nhẹ.',
    examples: ['back', 'job'],
  ),
  IPA(
    symbol: '/t/',
    description: 'Đọc giống âm T trong tiếng Việt nhưng bật hơi mạnh hơn.',
    mouthPosition:
        'Hai răng khít chặt, mở luồng khí thoát ra, nhưng không rung dây thanh quản.',
    tonguePosition:
        'Khi phát âm, bạn đặt đầu lưỡi dưới nướu. Khi bật luồng khí ra thì đầu lưỡi chạm vào răng cửa dưới.',
    examples: ['tea', 'tight', 'time', 'talk'],
  ),
  IPA(
    symbol: '/d/',
    description: 'Phát âm giống âm /d/ tiếng Việt, vẫn bật hơi mạnh hơn.',
    mouthPosition:
        'Hai răng khít, mở ra luồng khí và tạo độ rung cho thanh quản. ',
    tonguePosition:
        'Bạn đặt đầu lưỡi dưới nướu, khi luồng khí bật ra thì đầu lưỡi chạm vào răng cửa dưới',
    examples: ['day', 'date', 'dog'],
  ),
  IPA(
    symbol: '/t∫/',
    description: 'Cách đọc tương tự âm CH.',
    mouthPosition:
        'Nhưng khác là môi hơi tròn, khi ói phải chu ra về phía trước. Khi luồng khí thoát ra thì môi tròn nửa.',
    tonguePosition:
        'lưỡi thẳng và chạm vào hàm dưới, để khí thoát ra ngoài trên bề mặt lưỡi mà không ảnh hưởng đến dây thanh.',
    examples: ['church', 'match'],
  ),
  IPA(
    symbol: '/dʒ/',
    description: 'Phát âm giống / t∫ / nhưng có rung dây thanh quản.',
    mouthPosition: 'Môi hơi tròn, chi về trước. Khi khí phát ra,môi nửa tròn.',
    tonguePosition:
        'lưỡi thẳng và chạm vào hàm dưới, để khí thoát ra ngoài trên bề mặt lưỡi mà không ảnh hưởng đến dây thanh.',
    examples: ['age', 'gym'],
  ),
  IPA(
    symbol: '/k/',
    description: 'Phát âm giống âm K của tiếng Việt nhưng bật hơi mạnh.',
    mouthPosition: '',
    tonguePosition:
        'Nâng phần sau của lưỡi, chạm ngạc mềm, hạ thấp khi luồng khí mạnh bật ra và không tác động đến dây thanh',
    examples: ['key', 'school', 'chemistry', 'camping'],
  ),
  IPA(
    symbol: '/g/',
    description: 'Phát âm giống âm G của tiếng Việt.',
    mouthPosition: '',
    tonguePosition:
        'Khi đọc, bạn nâng phần sau của lưỡi, chạm ngạc mềm, hạ thấp khi luồng khí mạnh bật ra sao cho rung dây thanh.',
    examples: ['go', 'get', 'ghost'],
  ),
  IPA(
    symbol: '/f/',
    description: 'Phát âm giống âm PH của tiếng Việt.',
    mouthPosition: '',
    tonguePosition: 'Khi phát âm, hàm trên chạm nhẹ vào môi dưới..',
    examples: ['folk', 'fright', 'coffee', 'afraid'],
  ),
  IPA(
    symbol: '/v/',
    description: 'Phát âm giống âm V của tiếng Việt.',
    mouthPosition: '',
    tonguePosition: 'Khi phát âm, hàm trên sẽ chạm nhẹ vào môi dưới.',
    examples: ['vehicle', 'vet', 'vertical'],
  ),
  IPA(
    symbol: '/ð/',
    description: 'Phát âm giống âm V của tiếng Việt.',
    mouthPosition: '',
    tonguePosition:
        'Đặt đầu lưỡi ở giữa hai hàm răng, để luồng khí thoát ra giữa lưỡi và 2 hàm răng, thanh quản rung.',
    examples: ['this', 'other', 'them', 'then', 'breathe'],
  ),
  IPA(
    symbol: ' /θ/',
    description: 'Phát âm giống âm V của tiếng Việt.',
    mouthPosition: '',
    tonguePosition:
        'Đặt đầu lưỡi ở giữa hai hàm răng, để luồng khí thoát ra giữa lưỡi và 2 hàm răng, thanh quản không rung.',
    examples: ['think', 'path', 'breath'],
  ),
  IPA(
    symbol: ' /s/',
    description: 'Phát âm như âm S.',
    mouthPosition: '',
    tonguePosition:
        'Để lưỡi đặt nhẹ lên hàm trên, ngạc mềm nâng, luồng khí thoát từ giữa mặt lưỡi và lợi và không rung thanh quản',
    examples: ['sometimes', 'sister', 'soccer', 'sanctuary'],
  ),
  IPA(
    symbol: ' /z/',
    description:
        'Bạn phát âm bằng cách để lưỡi đặt nhẹ lên hàm trên, ngạc mềm nâng, luồng khí thoát từ giữa mặt lưỡi và lợi nhưng lại làm rung thanh quản.',
    mouthPosition: '',
    tonguePosition:
        'Để lưỡi đặt nhẹ lên hàm trên, ngạc mềm nâng, luồng khí thoát từ giữa mặt lưỡi và lợi nhưng lại rung thanh quản',
    examples: ['zero', 'buzz', 'zone', 'zebra'],
  ),
  IPA(
    symbol: '/∫/',
    description:
        'Khi đọc âm này, thì môi chu ra , hướng về phía trước và môi tròn. Mặt lưỡi chạm lợi hàm trên và nâng phần phía trước của lưỡi lên.',
    mouthPosition: 'Chu môi',
    tonguePosition:
        'Mặt lưỡi chạm lợi hàm trên và nâng phần phía trước của lưỡi lên',
    examples: ['sugar', 'she', 'sure', 'ship'],
  ),
  IPA(
    symbol: '/ʒ/',
    description:
        'Môi chu ra, hướng về phía trước, tròn môi. Để mặt lưỡi chạm lợi hàm trên và nâng phần phía trước của lưỡi lên và đọc rung thanh quản',
    mouthPosition: 'Chu môi, hướng về về phía trước, tròn môi',
    tonguePosition:
        'Mặt lưỡi chạm lợi hàm trên và nâng phần phía trước của lưỡi lên',
    examples: ['pleasurer', 'vision', 'january', 'jam'],
  ),
  IPA(
    symbol: '/m/',
    description: 'Giống âm M trong tiếng Việt',
    mouthPosition: 'Ngậm môi',
    tonguePosition: '',
    examples: ['make', 'mine', 'more', 'money'],
  ),
  IPA(
    symbol: '/n/',
    description: 'Giống âm N trong tiếng Việt',
    mouthPosition: 'Môi hé',
    tonguePosition: 'Đầu lưỡi chạm lợi hàm trên, chặn để khí phát ra từ mũi.',
    examples: ['not', 'naked', 'nice', 'sun'],
  ),
  IPA(
    symbol: '/ŋ/',
    description:
        'Khi phát âm thì chặn khí ở lưỡi, môi hé, khí phát ra từ mũi, môi hé, thanh quản rung, phần sau của lưỡi nâng lên, chạm vào ngạc mềm.',
    mouthPosition: 'Môi hé.',
    tonguePosition: 'Phần sau của lưỡi nâng lên, chạm vào ngạc mềm.',
    examples: ['ring', 'long', 'song', 'gang'],
  ),
  IPA(
    symbol: '/h/',
    description: 'Đọc như âm H của tiếng Việt.',
    mouthPosition: 'Môi hé nửa.',
    tonguePosition: 'lưỡi hạ thấp để khí thoát ra, thanh quản không rung',
    examples: ['hight', 'him', 'hold', 'hell'],
  ),
  IPA(
    symbol: '/l/',
    description:
        'Cong lưỡi từ từ, chạm răng hàm trên, thanh quản rung, môi mở rộng hoàn toàn, đầu lưỡi cong lên từ từ và đặt vào môi hàm trên.',
    mouthPosition: 'Môi mở rộng hoàn toàn.',
    tonguePosition: 'Đầu lưỡi cong lên từ từ và đặt vào môi hàm trên.',
    examples: ['love', 'live', 'style', 'feel'],
  ),
  IPA(
    symbol: '/r/',
    description:
        'Đọc khác âm R tiếng Việt nhé. Khi phát âm, bạn cong lưỡi vào trong, môi tròn, hơi chu về phía trước, Khi luồng khí thoát ra thì lưỡi thả lỏng, môi tròn mở rộng',
    mouthPosition:
        'Môi tròn, hơi chu về phía trước, luồng khí thoát ra thì môi tròn mở rộng.',
    tonguePosition: 'Lưỡi cong vào trong, luồng khí thoát ra thì lưỡi thả lỏng',
    examples: ['right', 'rock', 'sorry', 'remember'],
  ),
  IPA(
    symbol: '/w/',
    description:
        'Môi tròn, chu về phía trước, lưỡi thả lỏng. Khi luồng khí phát ra thì môi mở rộng, lưỡi vẫn thả lỏng',
    mouthPosition:
        'Môi tròn, chu về phía trước, luồng khí thoát ra thì môi mở rộng.',
    tonguePosition: 'Lưỡi thả lỏng',
    examples: ['wet', 'what', 'weather', 'work'],
  ),
  IPA(
    symbol: '/j/',
    description:
        'Khi phát âm, nâng phần trước lưỡi lên gần ngạc cứng, đẩy khí thoát ra giữa phần trước của lưỡi và ngạc cứng nhưng không có tiếng ma sát của luồng khí, làm rung dây thanh quản ở cổ họng. Môi hơi mở. Khi luồng khí phát ra thì môi mở rộng, phần giữa lưỡi hơi nâng lên, thả lỏng.',
    mouthPosition: 'Môi hơi hở ban đầu, luồng khí thoát ra thì môi mở rộng.',
    tonguePosition:
        'nâng phần trước lưỡi lên gần ngạc cứng, luồng khí thoát ra thì phần giữa lưỡi hơi nâng lên và thả lỏng',
    examples: ['university', 'reunion', 'yes', 'useless'],
  ),
];
