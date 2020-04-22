BUCKET ?= benbergstein
RECIPIENT=bennyjbergstein@gmail.com
PREFIX ?= /certs
CERT_DIR ?= letsencrypt

DOMAIN_ARGS=$(addprefix -d ,${DOMAINS})

define ARCHIVE
${CERT_DIR}.zip
endef

define ENCRYPTED_ARCHIVE
${ARCHIVE}.gpg
endef

define S3_URL
s3://${BUCKET}${PREFIX}
endef

bucket:
	s3cmd mb s3://${BUCKET}

zip:
	zip -r ${ARCHIVE} letsencrypt

encrypt:
	gpg -r ${RECIPIENT} -e < ${ARCHIVE} > ${ENCRYPTED_ARCHIVE}

decrypt:
	gpg -d < ${ENCRYPTED_ARCHIVE} > ${ARCHIVE}

upload:
	s3cmd put ${ENCRYPTED_ARCHIVE} ${S3_URL}/${ENCRYPTED_ARCHIVE}

download:
	s3cmd get ${S3_URL}/${ENCRYPTED_ARCHIVE} ${ENCRYPTED_ARCHIVE}

clean:
	rm ${ARCHIVE} ${ENCRYPTED_ARCHIVE}

push: zip encrypt upload clean
pull: download decrypt

create:
	DOMAINS="${DOMAIN_ARGS}" docker-compose -p https run --rm letsencrypt
