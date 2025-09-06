#!/bin/bash
# Project1 – Movies 

# Download Data Set
wget https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv

#Check data
ls -lh tmdb-movies.csv #Check file size & details
head -n 5 tmdb-movies.csv #Preview the first 5 lines:
wc -l tmdb-movies.csv #Count the number of lines:

echo "Q1: Sắp xếp các bộ phim theo ngày phát hành giảm dần rồi lưu ra một file mới"
mlr --csv sort -r release_date tmdb-movies.csv > movies_sorted.csv

echo "Q2: Lọc ra các bộ phim có đánh giá trung bình trên 7.5 rồi lưu ra một file mới"
mlr --csv filter '$vote_average >= 7.5' tmdb-movies.csv > movies_high_rating.csv

echo "Q3. Tìm ra phim nào có doanh thu cao nhất và doanh thu thấp nhất"
{ echo "=== Highest revenue movie ==="; mlr --csv sort -nr revenue tmdb-movies.csv |head -n 2; echo ""; echo "=== Lowest revenue movie ==="; mlr --csv sort -n revenue tmdb-movies.csv | head -n 2; } > revenue_highest_and_lowest.csv

echo "Q4: Tính tổng doanh thu tất cả các bộ phim"
mlr --csv stats1 -a sum -f revenue tmdb-movies.csv > revenue_total.csv

echo "Q5: Top 10 bộ phim đem về lợi nhuận cao nhất"
mlr --csv put '$profit=$revenue-$budget' tmdb-movies.csv | mlr --csv cut -f original_title,profit | mlr --csv sort -nr profit | head -n 11 > top10_protfit.csv

echo "Q6: Đạo diễn nào có nhiều bộ phim nhất và diễn viên nào đóng nhiều phim nhất"
( echo "=== TOP dao dien ===" ; mlr --csv cut -f director tmdb-movies.csv | mlr --csv count -g director| sort -t, -k2 -nr | head -n 1 ; echo "" ; echo "=== Top dien vien ===" ; mlr --csv cut -f cast tmdb-movies.csv | sed 1d | tr '|' '\n'| sed '/^$/d' | sort | uniq -c | sort -nr | head -n 1 ) | awk '{count=$1; $1=""; sub(/^ /,""); print $0 "," count}' > most_director_and_actor_movies.csv

echo "Q7: Thống kê số lượng phim theo các thể loại"
( mlr --csv cut -f genres tmdb-movies.csv | sed 1d | tr '|' '\n' | sed '/^$/d' |  sort | uniq -c | sort -nr ) > sort_movies.csv
