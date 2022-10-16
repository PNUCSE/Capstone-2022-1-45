# 블록체인 기반 신재생 에너지 거래 플랫폼
## Contents
### 1. [프로젝트 소개](#프로젝트-소개)
### 2. [팀 소개](#팀-소개)
### 3. [구성도](#구성도)
### 4. [소개 및 시연 영상](#소개-및-시연-영상)
### 5. [사용법](#사용법)
--- 
## 프로젝트 소개
### 블록체인 기반 신재생 에너지 거래 플랫폼
> #### 💡 왜 신재생 에너지 거래를 하나요❓
>> 글로벌 기후 위기를 몸소 체감한 지구촌은 이제 기업에게도 국가에게도 기후 위기 대응의 책임을 묻기 시작했습니다. 그 중 하나가 바로 경제활동에 필요한 에너지를 **얼마나 많은 신재생 에너지로 만들었느냐** 입니다. 이렇듯 신재생 에너지 생산의 중요성이 대두되며 우리 정부는 발맞춰 대형 발전소로 하여금 발전량의 일정 비율을 신재생 에너지로 생산하게 하는 의무 할당 제도를 시행하게 됩니다. 기업이든 대형 발전소든 신재생 에너지를 직접 생산할까요? 그러기엔 시간과 비용이 너무 많이 들죠. 따라서 이들은 **신재생에너지 공급 인증서**(`REC`)를 사들여 그 조건을 충족합니다. `REC`란 발전 사업자가 신재생 에너지를 이용해 에너지를 공급한 사실을 증명하는 인증서로, 발전 사업자는 이 인증서를 판매해 수익을, 구매자는 신재생 에너지를 공급한 것과 같은 인정을 얻을 수 있습니다.

> #### 💡 이 거래 플랫폼은 왜 필요한가요❓
>> 현재 REC 거래는 한국전력공사 또는 전력거래소 중심으로 이루어지고 있습니다. 하지만 그 과정이 복잡하고 소요기간이 상당하여 그로 인한 추가 비용이 발생합니다. 블록체인을 이용한 스마트 계약을 통해 복잡한 거래 **인증절차를 간소화**할 수 있고 블록체인이 중간 거래자의 역할을 대체함으로써 **거래 비용을 줄일 수** 있습니다. 또한, REC 거래 내역을 분산원장에 기록하면 누구나 거래 내역을 확인할 수 있으므로 **투명한 에너지 거래**가 가능하게 됩니다.
----
## 팀 소개
|이름|역할|이메일|
|:--:|:--:|:--:|
|안현주|모바일 클라이언트 개발|muzee99@pusan.ac.kr|
|차유진|블록체인 네트워크 개발<br>체인코드 개발<br>릴레이 서버 개발<br>모바일 클라이언트 개발|cyj89317@gmail.com.kr|
|이준영|블록체인 네트워크 개발<br>체인코드 개발<br>릴레이 서버 개발<br>모바일 클라이언트 개발|rubinstory@pusan.ac.kr|

---
## 구성도
![시스템 구성도](https://user-images.githubusercontent.com/54929223/195744674-d6958417-26ea-484c-bc5f-ac47afd9bdd3.png)

![](https://user-images.githubusercontent.com/54929223/195744444-7b67cd4d-e589-4225-aa03-fdb32698030f.png)
---
## 소개 및 시연 영상
<!-- [![](썸네일url)](영상url) -->

---
## 사용법
### 블록체인 네트워크
- Vagrant setup
블록체인 네트워크 실행은 Vagrant에서 됩니다.
```bash
go1.14.2
docker
docker-compose
node.js 10.x
```
실행을 위해 필요한 환경은 위와 같습니다.
- Vagrant 시작, 접속
```bash
vagrant up
vagrant ssh
```
- 블록체인 네트워크 실행
```bash
cd /vagrant/fabric-samples/pnu-server
./startFabric.sh
```
- 체인코드 배포
```bash
cd /vagrant/fabric-samples/pnu-network
./network.sh deployCC -v {버전(Int)}
```
- 중계 서버 실행
```bash
cd /vagrant/fabric-samples/pnu-server/javascript
## Wallet 생성
node enrollAdmin.js
node registerUser.js
## 서버 시작
node apiserver.js
```
- 커맨드라인 테스트
```bash
## 전체 거래 쿼리
curl http://localhost:8080/transaction/query-all/
## 유저 등록
curl -d '{"enrollmentID": 1, "departmentName": "buyer"}' -H "Content-Type: application/json" -X POST http://localhost:8080/register/
curl -d '{"enrollmentID": 2, "departmentName": "supplier"}' -H "Content-Type: application/json" -X POST http://localhost:8080/register/
## 공급자의 인증서 등록
curl -d '{"supplier": 2, "quantity": 10000000, "is_jeju": false, "supply_date": 1, "expire_date": 3}' -H "Content-Type: application/json" -X POST http://localhost:8080/certificate/register/
## 2의 등록된 인증서 조회
curl http://localhost:8080/certificate/query/2
## 2의 판매 등록
curl -d '{"target": "CERTIFICATE_1663057333", "price": 50000, "quantity": 100, "supplier": "2"}' -H "Content-Type: application/json" -X POST http://localhost:8080/transaction/create/
## 1의 구매 요청
curl -d '{"id": "TRANSACTION_1", "buyer": 1}' -H "Content-Type: application/json" -X POST http://localhost:8080/transaction/execute/
## 2 등록된 인증서 합 조회
curl http://localhost:8080/certificate/query-sum-by-supplier/2
## 1 구매한 인증서 합 조회
curl http://localhost:8080/certificate/query-sum-by-buyer/1
## 2의 구매 승인
curl -d '{"id": "TRANSACTION_1"}' -H "Content-Type: application/json" -X POST http://localhost:8080/transaction/approve/
curl http://localhost:8080/transaction/query-all/
```
- 블록체인 네트워크 종료
```bash
cd /vagrant/fabric-samples/pnu-server
./networkDown.sh
```
- Vagrant 종료
```bash
exit
vagrant halt
```
- 블록체인 네트워크 상태 저장하여 종료하기
```bash
cd /vagrant/fabric-samples/pnu-network/docker
./stopDocker.sh
```
- 블록체인 네트워크 저장된 상태로 시작하기
```bash
cd /vagrant/fabric-samples/pnu-network/docker
./startDocker.sh
```
### 백엔드 서버
- Python(3.8+)이 설치되어 있어야 합니다.

```bash
# Install Required Modules
pip3 install -r req.txt

# Move to django project folder
cd backend/rec

# Create Admin Account
python3 manage.py createsuperuser

# Initiate first migration
python3 manage.py makemigrations
python3 manage.py migrate

# Run server
python3 manage.py runserver {IP}:{PORT}
```
### iPad 어플리케이션
- XCode 14가 설치되어 있어야 합니다.
```bash
# Move to iPadOS project folder
cd iPadOS/TTS

# Install Pod Modules
pod install

# Open XCode and Build
open ./TTS.xcworkspace
```
