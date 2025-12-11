/**
 * Firebase Cloud Functions for Stock List Manager
 * .xlsb to .xlsx converter API
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { spawn } = require('child_process');
const path = require('path');

admin.initializeApp();

/**
 * .xlsb 파일을 .xlsx로 변환하는 Cloud Function
 * 
 * HTTP POST 요청:
 * - Body: .xlsb 파일 바이너리 데이터
 * - Content-Type: application/octet-stream
 * 
 * 응답:
 * - Body: .xlsx 파일 바이너리 데이터
 * - Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
 */
exports.convertXlsb = functions
  .region('asia-northeast3') // 서울 리전
  .runWith({
    timeoutSeconds: 120,     // 2분 타임아웃
    memory: '512MB',         // 512MB 메모리
  })
  .https.onRequest((req, res) => {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    // OPTIONS 요청 처리 (CORS preflight)
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // POST 요청만 허용
    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method not allowed' });
      return;
    }

    try {
      // 요청 본문에서 .xlsb 바이너리 데이터 읽기
      const xlsbBuffer = req.rawBody || req.body;

      if (!xlsbBuffer || xlsbBuffer.length === 0) {
        res.status(400).json({ 
          error: 'No file data received',
          message: '파일 데이터가 없습니다.'
        });
        return;
      }

      console.log(`📦 Received .xlsb file: ${xlsbBuffer.length} bytes`);

      // Python 변환 스크립트 실행
      const pythonScript = path.join(__dirname, 'convert_xlsb.py');
      const python = spawn('python3', [pythonScript]);

      let stdoutData = Buffer.alloc(0);
      let stderrData = '';

      // Python 프로세스로 .xlsb 데이터 전송
      python.stdin.write(xlsbBuffer);
      python.stdin.end();

      // 변환된 .xlsx 데이터 수신
      python.stdout.on('data', (data) => {
        stdoutData = Buffer.concat([stdoutData, data]);
      });

      // 에러 메시지 수신
      python.stderr.on('data', (data) => {
        stderrData += data.toString();
      });

      // 변환 완료 처리
      python.on('close', (code) => {
        if (code !== 0) {
          console.error(`❌ Conversion failed: ${stderrData}`);
          res.status(500).json({
            error: 'Conversion failed',
            message: `변환 중 오류 발생: ${stderrData}`
          });
          return;
        }

        console.log(`✅ Conversion successful: ${stdoutData.length} bytes`);

        // .xlsx 파일 응답
        res.set('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.set('Content-Disposition', 'attachment; filename="converted.xlsx"');
        res.status(200).send(stdoutData);
      });

    } catch (error) {
      console.error('❌ Error:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: error.message
      });
    }
  });

/**
 * API 서버 상태 확인
 */
exports.health = functions
  .region('asia-northeast3')
  .https.onRequest((req, res) => {
    res.set('Access-Control-Allow-Origin', '*');
    res.status(200).json({
      status: 'ok',
      service: 'xlsb-converter',
      version: '1.0.0',
      timestamp: new Date().toISOString()
    });
  });
