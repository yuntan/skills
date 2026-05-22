# 個人開発プランニングガイド (izanami.dev)

## アイデア創出：引き算と足し算

### 引き算（Less is More）
既存のサービスから「手間」や「コスト」を削ることで価値を生む。
- **インストール不要**: (例: Figma)
- **UIの簡素化・情報の取捨選択**: (例: Notion, Google Search)
- **キャッシュレス・手続きの自動化**: (例: Uber)
- **学習コストの削減**: (例: Canva)

### 足し算（Value Added）
既存のサービスに「便利」や「お得」を足すことで差別化する。
- **テンプレート・プリセット**: (例: Vercel, Shopify)
- **他サービスとの統合 (Integration)**: (例: Slack Connect)
- **無料枠の拡大・Freemium**: (例: Cloudflare)
- **コミュニティ・ソーシャル機能**: (例: GitHub)

## 技術選定：用途別推奨スタック

### 1. SaaS / 管理画面系 (スピード・拡張性重視)
- **Stack**: Remix + Supabase + Stripe
- **特徴**: Web標準に近い開発体験。Supabase Auth/DBでバックエンド構築を最小化。

### 2. メディア / ブログ / ポートフォリオ (SEO・表示速度重視)
- **Stack**: SvelteKit + Cloudflare Pages + Contentful
- **特徴**: 軽量・高速なレンダリング。エッジでの配信。

### 3. AI / データ分析アプリ (プロトタイプ重視)
- **Stack**: Streamlit + FastAPI + Neon (Postgres)
- **特徴**: Pythonのみで高速にUI構築。NeonのサーバーレスDBでコスト最適化。

### 4. モバイルアプリ (クロスプラットフォーム重視)
- **Stack**: React Native (Expo) / Flutter + Firebase
- **特徴**: ワンソース・マルチデバイス。Firebaseによるモバイル機能の統合。

## コストの落とし穴 (危険度ランキング)
1. **画像・動画ストレージ**: 生のS3等は転送料で詰む。Cloudflare R2やCloudinaryを検討。
2. **認証システム**: Auth0等の従量課金。Supabase AuthやClerkの無料枠を賢く使う。
3. **データベース**: 常に起動しているDBインスタンス。NeonやCloudflare D1などのサーバーレスを検討。
4. **ホスティング**: 固定費がかかるVPS。VercelやRailwayの無料枠から始める。
