for file in $(find ~ -name "*.backup"); do
    mv "$file" "${file/.backup/}"
done
