#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
.xlsb → .xlsx 변환 API 서버
Flutter 앱에서 HTTP POST로 .xlsb 파일을 보내면 .xlsx로 변환하여 반환
"""

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import io
import sys
import os

# 변환 스크립트 import
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'scripts'))
from convert_xlsb_to_xlsx import convert_xlsb_to_xlsx_bytes

app = Flask(__name__)
CORS(app)  # CORS 허용 (Flutter 웹에서 접근 가능)


@app.route('/health', methods=['GET'])
def health_check():
    """API 서버 상태 확인"""
    return jsonify({
        'status': 'ok',
        'service': 'xlsb-converter',
        'version': '1.0.0'
    })


@app.route('/convert', methods=['POST'])
def convert_xlsb():
    """
    .xlsb 파일을 .xlsx로 변환
    
    Request:
        - Body: .xlsb 파일 바이너리 데이터
        - Content-Type: application/octet-stream 또는 multipart/form-data
    
    Response:
        - Body: .xlsx 파일 바이너리 데이터
        - Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    """
    try:
        # 파일 데이터 읽기
        if 'file' in request.files:
            # multipart/form-data 방식
            xlsb_file = request.files['file']
            xlsb_bytes = xlsb_file.read()
        else:
            # application/octet-stream 방식
            xlsb_bytes = request.get_data()
        
        if not xlsb_bytes:
            return jsonify({
                'error': 'No file data received',
                'message': '파일 데이터가 없습니다.'
            }), 400
        
        # .xlsb → .xlsx 변환
        xlsx_bytes = convert_xlsb_to_xlsx_bytes(xlsb_bytes)
        
        # 변환된 .xlsx 파일 반환
        return send_file(
            io.BytesIO(xlsx_bytes),
            mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            as_attachment=True,
            download_name='converted.xlsx'
        )
        
    except Exception as e:
        return jsonify({
            'error': 'Conversion failed',
            'message': f'변환 중 오류 발생: {str(e)}'
        }), 500


@app.route('/', methods=['GET'])
def index():
    """API 사용 안내"""
    return jsonify({
        'service': 'XLSB to XLSX Converter API',
        'version': '1.0.0',
        'endpoints': {
            'GET /health': 'API 서버 상태 확인',
            'POST /convert': '.xlsb 파일을 .xlsx로 변환',
        },
        'usage': {
            'method': 'POST',
            'url': '/convert',
            'content-type': 'application/octet-stream 또는 multipart/form-data',
            'body': '.xlsb 파일 바이너리 데이터',
            'response': '.xlsx 파일 바이너리 데이터'
        }
    })


if __name__ == '__main__':
    # 포트 5061 사용 (Flutter 앱은 5060)
    app.run(host='0.0.0.0', port=5061, debug=False)
