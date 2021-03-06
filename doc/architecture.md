# Architecture

## Models

### `app/models/crawler.rb`

儲存爬蟲的設定檔，比如：

* 爬蟲需要爬的學期年分別(`year`/`term`)
* 上次與 Core 同步的時間(`last_sync_at`, 已棄用)
* [`jmettraux/rufus-scheduler`](https://github.com/jmettraux/rufus-scheduler) 的排程設定(`setting` 裡面)
* 學校代碼（`organization_code`）
* 爬蟲是否要儲存到 database(dry run, `save_to_db`, boolean)
* 爬蟲是否要同步到 Colorgy(`sync`, boolean, 已棄用)
* 在 Colorgy 上的 table 名稱（`data_name`, 已棄用）

也包含一些和爬蟲程式建立 record 的邏輯等等。

### `app/models/course.rb`

儲存爬蟲抓下來的課程資料。

#### 欄位說明

請參照[爬蟲開發指南](./crawler_development_guide.md#規格)

## Crawlers

目前各校的課程爬蟲都在 `lib/course_crawler/crawlers` 此目錄下。參見 [爬蟲開發指南](./crawler_development_guide.md)

## Workers

### CourseCrawlerJob

CourseCrawlerJob（`app/jobs/course_crawler_job.rb`）負責：

* 把課程爬蟲放進 Sidekiq Process 裡面跑
* 儲存至 Database

### CourseSyncJob

CourseSyncJob（`app/jobs/course_sync_job`）負責：

* 轉換 Course 成新版 Course model 寫入主要 repo 的 database
* 根據新轉換的 Course，產生 json 存到 s3
